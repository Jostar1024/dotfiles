{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };
  home.packages = with pkgs; [
    stow
    curl
    wget
    neofetch

    # programming
    asdf-vm
    elixir-ls
    terraform
    clj-kondo
    cljfmt
    stylelint
    nodePackages.js-beautify
    shellcheck
    rustup
    rustc
    dockfmt
    shfmt
    nixfmt
    racket
    pandoc
    haskellPackages.lsp
    haskellPackages.cabal-install

    # utils
    ripgrep
    findutils
    fd
    fzf
    jq
    yq-go
    eza
    comma
    
    # libs
    librime
    fontconfig
    coreutils
    aspell

    # softwares    
    alacritty
    syncthing
    keepassxc

    # fonts
    jetbrains-mono
    lxgw-wenkai
  ];
  programs.home-manager.enable = true;
}
