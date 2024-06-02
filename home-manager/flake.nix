{
  description = "Home Manager configuration of yucheng";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # NOTE: how to use both stable & unstable
    # https://www.reddit.com/r/NixOS/comments/15zd11c/using_both_2305_unstable_in_homemanager/
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    darwin,
    ...
  }: let
    pkgs-stable-func = system: nixpkgs-stable.legacyPackages."${system}";
  in {
    homeConfigurations."yuchengcao" = let
      pkgs-stable = pkgs-stable-func "aarch64-darwin";
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home/darwin.nix
          ./home/common.nix
        ];
        extraSpecialArgs = {inherit pkgs-stable;};
      };

    homeConfigurations."yucheng" = let
      pkgs-stable = pkgs-stable-func "x86_64-linux";
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home/linux.nix
          ./home/common.nix
        ];
        extraSpecialArgs = {inherit pkgs-stable;};
      };
  };
}
