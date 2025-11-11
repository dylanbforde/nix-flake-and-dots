# /home/dylan/nixos-config/modules/home-manager.nix
{ inputs, ... }:
{
  # Pass the flake inputs to the home-manager modules
  home-manager.extraSpecialArgs = { inherit inputs; };

  home-manager.users.dylan = {
    imports = [ ./home.nix ];
  };
}
