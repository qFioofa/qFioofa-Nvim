{
  description = "qFioofa Neovim config — Home Manager module";

  # See scripts/deploy.sh: the repo root is the config root, target is
  # ~/.config/nvim (deploy.sh runs `cp -r "$CURRENT_DIR/." ~/.config/nvim`).
  outputs = { self }: {
    homeManagerModules.default = { config, lib, pkgs, ... }:
      let
        # --- Why this exists ---------------------------------------------------
        # Mason downloads *precompiled, dynamically-linked* binaries (LSP
        # servers, formatters, linters) plus runs npm/pip/go to build others.
        # Those ELF binaries expect a standard FHS layout: a dynamic loader at
        # /lib64/ld-linux-x86-64.so.2 and shared libs under /lib and /usr/lib.
        # NixOS has none of that, so even though Mason's symlinks in
        # ~/.local/share/nvim/mason/bin resolve fine, launching the tool fails
        # with "No such file or directory" on the missing ELF interpreter.
        #
        # The fix: run Neovim inside an FHS sandbox (buildFHSEnv). The sandbox
        # synthesizes a conventional /usr, /lib and dynamic loader from the Nix
        # store, bind-mounts the real /home and /nix, and is writable — so Mason
        # can both *install* and *run* its tools unchanged. Everything below is
        # just deciding which libraries/runtimes live inside that sandbox.
        nvim-fhs = pkgs.buildFHSEnv {
          # Produces $out/bin/nvim, shadowing any other nvim on PATH.
          name = "nvim";

          targetPkgs = p: (with p; [
            # The editor itself (unwrapped: the FHS env is our wrapper).
            neovim-unwrapped

            # Shared libraries that prebuilt Mason binaries link against.
            stdenv.cc.cc      # libstdc++ / libgcc_s — clangd, lua-language-server, stylua, ...
            zlib
            openssl
            ncurses           # libtinfo — clangd and other terminal-aware tools
            icu               # marksman (.NET), and ICU-dependent tools
            libxml2
            curl

            # Language runtimes Mason uses to fetch / build / run servers and
            # formatters. Mapped to the tools in lspconfig/options.lua + conform.
            nodejs            # ts_ls, eslint, svelte, bashls, dockerls, prettier
            python3           # pyright, ruff, black, isort
            go                # gopls, shfmt
            rustc             # taplo (taplo is also distributed prebuilt)
            cargo
            jdk17             # lemminx (XML language server is JVM-based)

            # Generic build / fetch toolchain Mason invokes during installs.
            gcc
            gnumake
            unzip
            gzip
            gnutar
            wget
            git
          ]);

          # Let dynamically-linked tools also find libs via the conventional
          # search path inside the sandbox.
          profile = ''
            export LD_LIBRARY_PATH=/lib:/lib64:/usr/lib:/usr/lib64:''${LD_LIBRARY_PATH:-}
          '';

          # buildFHSEnv appends "$@", so `nvim file.lua`, flags, etc. all work.
          runScript = "nvim";
        };
      in
      {
        # Install the wrapped editor. This flake now provides `nvim`, so drop
        # any other Neovim package from your Home Manager config to avoid a
        # PATH clash.
        home.packages = [ nvim-fhs ];

        xdg.configFile."nvim" = {
          recursive = true;
          source = ./.;
        };
      };
  };
}
