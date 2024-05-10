{
  config,
  lib,
  pkgs,
  ...
}: {
  home.homeDirectory = "/Users/yuchengcao";
  home.packages = with pkgs; [
    emacs
  ];
}
