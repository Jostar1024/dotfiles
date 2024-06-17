{
  config,
  lib,
  pkgs,
  ...
}: let
  font = "FiraCode Nerd Font Mono";
  decoration =
    if pkgs.lib.strings.hasSuffix "darwin" pkgs.system
    then "buttonless"
    else "none";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = ["${pkgs.alacritty-theme}/tokyo-night.toml"];
      env = {
        TERM = "xterm-256color";
      };
      shell = {program = "zsh";};
      window = {
        padding.x = 14;
        padding.y = 14;
        decorations = decoration;
        opacity = 0.97;
        dimensions = {
          lines = 80;
          columns = 200;
        };
      };
      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ];
      font = {
        size = 14;
        normal = {
          family = font;
          style = "Retina";
        };
        bold = {
          family = font;
          style = "Bold";
        };
        italic = {
          family = font;
          style = "Italic";
        };
      };
    };
  };
}
