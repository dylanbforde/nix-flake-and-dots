{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Explicitly enable firewall for defense-in-depth security
  # Ensure all unsolicited incoming connections are blocked by default
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;
}
