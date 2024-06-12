{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ../programs/tmux.nix
    ../programs/zsh.nix
    ../programs/starship.nix
    ../programs/alacritty.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home.packages =
    (with pkgs-stable; [
      emacs-lsp-booster
    ])
    ++ (with pkgs; [
      # ai
      ollama

      # utils
      stow
      curl
      wget
      neofetch
      bat
      pgcli
      htop
      tree
      flyctl
      visidata
      tealdeer
      ripgrep
      findutils
      fd
      fzf
      jq
      yq-go
      eza
      comma
      zellij
      nix-search-cli
      manix

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
      nodePackages.prettier
      shellcheck
      rustup
      rustc
      dockfmt
      shfmt
      nixfmt-classic
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
      cascadia-code
      fira-code
      (pkgs.nerdfonts.override {fonts = ["FiraCode" "CascadiaCode" "JetBrainsMono"];})
      lxgw-wenkai
    ]);
  programs.home-manager.enable = true;
}
