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
    shellAliases = {
      ls = "eza";
      l = "eza -lh";
      la = "eza -la";
      ip = "ip --color=auto";
      hms = "home-manager switch";
    };
    initExtra = "
      export PATH=$PATH:~/.config/emacs/bin
      export KERL_BUILD_DOCS=yes
      export KERL_INSTALL_MANPAGES=yes
      export KERL_INSTALL_HTMLDOCS=yes

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
}
