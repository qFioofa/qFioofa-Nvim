{
  description = "qFioofa Neovim config — Home Manager module";

  outputs = { self }: {
    homeManagerModules.default = { config, lib, pkgs, ... }:
      let
        # Mason installs prebuilt, dynamically-linked binaries that expect an
        # FHS layout (/lib64/ld-linux..., /usr/lib). NixOS has none, so they
        # fail with "No such file or directory". Running Neovim inside an FHS
        # sandbox gives Mason a normal filesystem to install into and run from.
        nvim = pkgs.buildFHSEnv {
          name = "nvim";
          runScript = "nvim";

          targetPkgs = p: with p; [
            neovim-unwrapped

            # Shared libs the prebuilt tools link against.
            stdenv.cc.cc        # libstdc++ / libgcc_s
            zlib openssl
            ncurses             # libtinfo (clangd, ...)
            icu                 # marksman

            # Runtimes Mason uses to fetch/build/run servers and formatters.
            nodejs python3 go
            jdk17               # lemminx

            # Install toolchain Mason shells out to.
            gcc gnumake curl wget git unzip gzip gnutar
          ];

          profile = "export LD_LIBRARY_PATH=/usr/lib:/usr/lib64:\${LD_LIBRARY_PATH:-}";
        };
      in
      {
        home.packages = [ nvim ];

        xdg.configFile."nvim" = {
          recursive = true;
          source = ./.;
        };
      };
  };
}
