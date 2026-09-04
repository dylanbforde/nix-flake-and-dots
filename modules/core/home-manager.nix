{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Pass the flake inputs to the home-manager modules
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.dylan = {
      imports = [
        ../home/default.nix
        ../theme/default.nix
      ];
    };
  };
}
