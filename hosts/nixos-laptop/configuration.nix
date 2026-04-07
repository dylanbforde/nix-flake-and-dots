# /home/dylan/nixos-config/hosts/nixos-laptop/configuration.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/core/default.nix
    ../../modules/networking/default.nix
    ../../modules/programs/common.nix
    ../../modules/programs/dev.nix
    ../../modules/programs/kitty/default.nix
    ../../modules/desktop/hyprland/default.nix
    ../../modules/desktop/waybar/default.nix
    ../../modules/desktop/wofi/default.nix
    ../../modules/programs/fastfetch/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  services.tlp.enable = true;
  services.thermald.enable = true;

  networking.hostName = "nixos-laptop";
  system.stateVersion = "25.05";
}