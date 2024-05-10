{
  description = "Home Manager configuration of yucheng";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    home-manager,
    darwin,
    ...
  }: {
    darwinConfigurations = {
      armMac = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          home-manager.darwinModules.default
          ./arm-mac.nix
        ];
        specialArgs = {inherit inputs;};
      };
    };

    homeConfigurations."yucheng" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [./linux.nix];
    };
  };
}
