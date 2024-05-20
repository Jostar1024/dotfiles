{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
  home.packages = with pkgs; [
    # ai
    ollama

    # utils
    stow
    curl
    wget
    neofetch
    starship
    bat
    pgcli
    htop
    tree
    flyctl
    visidata

    # programming
    alejandra
    nil
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
    haskellPackages.hoogle
    haskellPackages.cabal-install

    podman-compose
    # erlang deps
    fop
    jdk21
    wxGTK32
    unixODBC
    openssl

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
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science fr]))
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
