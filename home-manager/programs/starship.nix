{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ starship ];
  home.file = {
    # https://github.com/nix-community/home-manager/issues/257#issuecomment-831300021
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath "${config.home.homeDirectory}/.dotfiles/starship/starship.toml");
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
