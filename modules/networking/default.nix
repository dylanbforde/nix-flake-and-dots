{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Explicitly enable the firewall (Defense in Depth)
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;
}
