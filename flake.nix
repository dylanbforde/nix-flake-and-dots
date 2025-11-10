{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  inputs.cursor.url = "github:dylanbforde/nix-ide-flake";

  outputs = { self, nixpkgs, home-manager, cursor, ... }@inputs: {
    # NixOS Configs
    nixosConfigurations = {
      "nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-laptop/configuration.nix

          ./modules/common.nix
          
          ./modules/home-manager.nix

          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
