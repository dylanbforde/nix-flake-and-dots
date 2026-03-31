{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Explicitly enable firewall for defense-in-depth
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
