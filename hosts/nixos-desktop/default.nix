# /home/dylan/nixos-config/hosts/nixos-desktop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    # ./hardware-configuration.nix # You must generate this on the desktop!
    
    ../../modules/core/default.nix
    ../../modules/networking/default.nix
    ../../modules/programs/common.nix
    ../../modules/programs/dev.nix
    ../../modules/desktop/hyprland/default.nix
  ];

  networking.hostName = "nixos-desktop";
  system.stateVersion = "25.05";
}
