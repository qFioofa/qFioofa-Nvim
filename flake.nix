{
  description = "qFioofa Neovim config — Home Manager module";

  # See scripts/deploy.sh: the repo root is the config root, target is
  # ~/.config/nvim (deploy.sh runs `cp -r "$CURRENT_DIR/." ~/.config/nvim`).
  outputs = { self }: {
    homeManagerModules.default = { config, lib, pkgs, ... }: {
      xdg.configFile."nvim" = {
        recursive = true;
        source = ./.;
      };
    };
  };
}
