# /home/dylan/nixos-config/modules/home-manager.nix
{
  # This file imports your existing home-manager configuration.
  home-manager.users.dylan = import ./home.nix;
}
