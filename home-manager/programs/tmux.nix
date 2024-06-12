{
  config,
  lib,
  pkgs,
  ...
}: let
  thumbsCopy =
    if pkgs.lib.strings.hasSuffix "darwin" pkgs.system
    then "set -g @thumbs-command 'echo -n {} | pbcopy'"
    else "";
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 30000;
    customPaneNavigationAndResize = true;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      catppuccin
      tmux-thumbs
      fuzzback
    ];
    prefix = "C-s";
    mouse = true;
    extraConfig = ''
      unbind r
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

      # https://www.reddit.com/r/tmux/comments/sv6skh/clickable_urls/
      bind-key i run-shell -b "tmux capture-pane -J -p | grep -oE '(https?):\/\/.*[^>]' | fzf-tmux -d20 --multi --bind alt-a:select-all,alt-d:deselect-all | xargs open"

      set -g @fuzzback-popup 1
      set -g @fuzzback-hide-preview 1
      set -g @fuzzback-popup-size '90%'

      ${thumbsCopy}

      # remain in copy mode
      set -g @yank_action 'copy-pipe'
      set -g @yank_with_mouse on

      set-option -g status-position top

      # catppuccin config 3 from:
      # https://github.com/catppuccin/tmux
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"

      set -g @catppuccin_status_modules_right "session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"
    '';
  };
}
