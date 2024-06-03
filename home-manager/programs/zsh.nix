{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.ignoreDups = true;
    sessionVariables = {
      EDITOR = "emacs";
      LANG = "en_US.UTF-8";
    };
    localVariables = {
      KERL_BUILD_DOCS = "yes";
      KERL_INSTALL_MANPAGES = "yes";
      KERL_INSTALL_HTMLDOCS = "yes";
    };
    shellAliases = {
      ls = "eza";
      l = "eza -lh";
      la = "eza -la";
      hms = "home-manager switch";
      tn = "tmux new-session -A -s";
      ta = "tmux attach -t";
      k = "kubectl";
      cat = "bat --style=plain --pager=never";
    };
    initExtra = ''
      # export LANG=en_US.UTF-8
      export PATH=$PATH:~/.config/emacs/bin

      # -X leaves file contents on the screen when less exits.
      # -F makes less quit if the entire output can be displayed on one screen.
      # -R displays ANSI color escape sequences in "raw" form.
      # -S disables line wrapping. Side-scroll to see long lines.
      export LESS="-SRXF"
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      export HISTCONTROL=ignoredups

      source ~/.zshrc

      eval "$(starship init zsh)"
      . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"
      . "$HOME/.nix-profile/share/bash-completion/completions/asdf.bash"
    '';
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    dotDir = ".config/zsh";
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "fzf" "direnv" "sudo"];
    };
  };
}
