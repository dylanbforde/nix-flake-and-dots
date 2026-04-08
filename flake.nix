{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: 
  let
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        system = prev.system;
        config.allowUnfree = true;
      };
    };
  in {
    # NixOS Configs
    nixosConfigurations = {
      # Laptop Configuration
      "nixos-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-laptop/configuration.nix
          ./modules/core/home-manager.nix
          ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        ];
      };

      # Desktop Configuration
      "nixos-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-desktop/default.nix
          ./modules/core/home-manager.nix
          ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
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
