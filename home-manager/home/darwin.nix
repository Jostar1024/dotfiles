{
  config,
  lib,
  pkgs,
  ...
}: {
  home.username = "yuchengcao";
  home.homeDirectory = "/Users/yuchengcao";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    emacs
    iterm2
    darwin.iproute2mac
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.ignoreDups = true;
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
    initExtra = "
      export LANG=en_US.UTF-8
      export PATH=$PATH:~/.config/emacs/bin
      export KERL_BUILD_DOCS=yes
      export KERL_INSTALL_MANPAGES=yes
      export KERL_INSTALL_HTMLDOCS=yes
      export LESS=\"-SRXF\"

      source ~/.zshrc

      eval \"$(starship init zsh)\"
      . \"$HOME/.nix-profile/share/asdf-vm/asdf.sh\"
      . \"$HOME/.nix-profile/share/bash-completion/completions/asdf.bash\"
    ";
    profileExtra = "
      eval \"$(/opt/homebrew/bin/brew shellenv)\"
    ";
    dotDir = ".config/zsh";
  };
  programs.tmux = {
    enable = true;
  };
}
