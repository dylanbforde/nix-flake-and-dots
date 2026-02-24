{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # NixOS Configs
    nixosConfigurations = {
      # Laptop Configuration
      "nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-laptop/configuration.nix
          ./modules/core/home-manager.nix
        ];
      };

      # Desktop Configuration
      "nixos-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-desktop/default.nix
          ./modules/core/home-manager.nix
        ];
      };
    };

    checks = let
      system = "x86_64-linux";
    in {
      ${system} = {
        nixos-laptop = self.nixosConfigurations.nixos-laptop.config.system.build.toplevel;
        nixos-desktop = self.nixosConfigurations.nixos-desktop.config.system.build.toplevel;
      };
    };
  };
}
