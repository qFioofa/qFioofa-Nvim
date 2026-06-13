{
  description = "qFioofa Neovim — self-contained, Mason-ready Neovim for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

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
      # /etc/nixos — the fix lives entirely in this flake.
      nvim = pkgs.buildFHSEnv {
        name = "nvim";
        runScript = "nvim";

        targetPkgs = p: with p; [
          neovim-unwrapped

          # Shared libs the prebuilt servers link against.
          stdenv.cc.cc        # libstdc++ / libgcc_s  (clangd, lua-language-server)
          zlib openssl        # clangd, lemminx, marksman (.NET)
          ncurses             # libtinfo (clangd)
          icu                 # marksman (.NET globalization)

          # Runtimes Mason uses to fetch/build/run servers & formatters.
          nodejs python3 go
          jdk17               # in case a JVM-backed server is added

          # Install toolchain Mason shells out to, plus tools the config uses.
          gcc gnumake curl wget git unzip gzip gnutar ripgrep fd
        ];

        # Belt-and-braces for servers that dlopen libs by soname at runtime
        # (e.g. marksman pulling in libicu): point the loader at /usr/lib too.
        profile = ''
          export LD_LIBRARY_PATH=/usr/lib:/usr/lib64''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
        '';
      };
    in
    {
      # `nix profile install .` / `nix run .` — a Neovim whose Mason servers work.
      packages.${system} = {
        default = nvim;
        nvim = nvim;
      };

      apps.${system}.default = {
        type = "app";
        program = "${nvim}/bin/nvim";
      };

      # For Home Manager users: installs the FHS Neovim and symlinks this repo
      # to ~/.config/nvim so the config ships with it.
      homeManagerModules.default = { ... }: {
        home.packages = [ nvim ];
        xdg.configFile."nvim" = {
          recursive = true;
          source = ./.;
        };
      };
    };
}
