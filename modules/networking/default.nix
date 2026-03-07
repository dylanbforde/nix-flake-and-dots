{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Defense-in-depth: Explicitly enable firewall
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;
}
