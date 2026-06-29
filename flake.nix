{
  description = "qFioofa Neovim — self-contained, Mason-ready Neovim for NixOS (0.11.7 + 0.12.x)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  # Pinned to the same revision used by qFioofa-NixOS so the Neovim build
  # inputs match the 0.11.7 override below.
  inputs.nixpkgs-nvim.url = "github:NixOS/nixpkgs/832efc09b4caf6b4569fbf9dc01bec3082a00611";

  outputs = { self, nixpkgs, nixpkgs-nvim }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgsNvim = nixpkgs-nvim.legacyPackages.${system};

      # 0.11.7 — pinned (lockstep with qFioofa-NixOS). Runs the lazy.nvim profile.
      neovim-0_11_7 = pkgsNvim.neovim-unwrapped.overrideAttrs (old: rec {
        version = "0.11.7";
        src = pkgsNvim.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "v${version}";
          hash = "sha256-NAZAp4WSKYcEmwzhTy/OwYY4KO/dsUtjD0ddzMwm+8Q=";
        };
      });

      # 0.12.x — straight from nixos-unstable (currently 0.12.3). Runs the native
      # vim.pack profile (no lazy.nvim, native LSP + completion). No source
      # override/hash needed: nixpkgs already ships it.
      #
      # nixpkgs builds neovim's bundled tree-sitter parsers from each grammar
      # tarball's *checked-in* src/parser.c without re-running `tree-sitter
      # generate`. For some grammars that parser.c lags grammar.js and the
      # runtime queries neovim 0.12.x ships, so highlighting (and noice's
      # treesitter-highlighted cmdline) dies with `Invalid field name ...`.
      # E.g. lua's binary_expression has no `operator` field but the query
      # needs it. Reproduce on a clean editor: `nvim --clean some.lua`.
      # Fix: regenerate parser.c for the affected grammars. Add a language to
      # the list if `nvim --clean <file>` shows the same query error for it.
      regenLangs = [ "lua" ];
      regenTSParser = g: g.overrideAttrs (o: {
        nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ pkgs.tree-sitter pkgs.nodejs ];
        preBuild = (o.preBuild or "") + "\ntree-sitter generate\n";
      });
      neovim-0_12 = pkgs.neovim-unwrapped.overrideAttrs (old: {
        treesitter-parsers = old.treesitter-parsers
          // builtins.listToAttrs (map
            (l: { name = l; value = regenTSParser old.treesitter-parsers.${l}; })
            regenLangs);
      });

      # Mason installs prebuilt, dynamically-linked servers (clangd,
      # lua-language-server, marksman, lemminx, taplo, ...) built for a
      # generic-FHS Linux: they expect /lib64/ld-linux-x86-64.so.2 and an
      # /usr/lib layout. NixOS ships only a stub linker there, so the moment
      # Neovim spawns them the LSP client reports "exited with code 127".
      #
      # Running Neovim inside a buildFHSEnv sandbox gives both Neovim AND every
      # LSP/formatter it spawns a normal FHS filesystem (real loader + libs in
      # /usr/lib), so the prebuilt binaries run unmodified. This is fully
      # self-contained: no system-level programs.nix-ld, no root, no edits to
      # /etc/nixos — the fix lives entirely in this flake. Version-agnostic, so
      # both the 0.11.7 and 0.12.x builds share it.
      mkNvim = neovim: pkgs.buildFHSEnv {
        name = "nvim";
        runScript = "nvim";

        targetPkgs = p: with p; [
          neovim

          # Shared libs the prebuilt servers link against.
          stdenv.cc.cc        # libstdc++ / libgcc_s  (clangd, lua-language-server)
          zlib openssl        # clangd, lemminx, marksman (.NET)
          ncurses             # libtinfo (clangd)
          icu                 # marksman (.NET globalization)

          # Runtimes Mason uses to fetch/build/run servers & formatters.
          nodejs python3 go
          jdk21               # Java: jdtls (needs 21+), java-debug-adapter,
                              # java-test, google-java-format all run on the JVM

          # Install toolchain Mason shells out to, plus tools the config uses.
          gcc gnumake curl wget git unzip gzip gnutar ripgrep fd
        ];

        # Belt-and-braces for servers that dlopen libs by soname at runtime
        # (e.g. marksman pulling in libicu): point the loader at /usr/lib too.
        profile = ''
          export LD_LIBRARY_PATH=/usr/lib:/usr/lib64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
          export CGO_ENABLED=0
        '';
      };

      nvim-0_11 = mkNvim neovim-0_11_7;
      nvim-0_12 = mkNvim neovim-0_12;
    in
    {
      # Install:  nix profile install .#nvim-0_12   (or .#nvim-0_11)
      # Run:      nix run .#nvim-0_12               (or .#nvim-0_11)
      # `default` is 0.12.x (native vim.pack profile); use nvim-0_11 for 0.11.7.
      packages.${system} = {
        default = nvim-0_12;
        nvim-0_11 = nvim-0_11;
        nvim-0_12 = nvim-0_12;
      };

      apps.${system} = {
        default = self.apps.${system}.nvim-0_12;
        nvim-0_11 = {
          type = "app";
          program = "${nvim-0_11}/bin/nvim";
        };
        nvim-0_12 = {
          type = "app";
          program = "${nvim-0_12}/bin/nvim";
        };
      };

      # For Home Manager users: installs the FHS Neovim and symlinks this repo
      # to ~/.config/nvim so the config ships with it. Swap nvim-0_12 -> nvim-0_11
      # to stay on the 0.11.7 (lazy) profile.
      homeManagerModules.default = { ... }: {
        home.packages = [ nvim-0_12 ];
        xdg.configFile."nvim" = {
          recursive = true;
          source = ./.;
        };
      };
    };
}
