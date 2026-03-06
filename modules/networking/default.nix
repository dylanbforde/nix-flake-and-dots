{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;
}
