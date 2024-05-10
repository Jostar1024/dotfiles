{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    curl
    wget
    neofetch
  ];
}
