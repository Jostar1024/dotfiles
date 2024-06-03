{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 30000;
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
    ];
  };
}
