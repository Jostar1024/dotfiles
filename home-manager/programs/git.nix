{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.git.enable = true;
  programs.git.ignores = [
    ".DS_Store"
    ".projectile"
  ];
}
