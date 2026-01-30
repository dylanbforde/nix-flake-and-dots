{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;
}
