{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Explicitly enable the firewall for defense-in-depth security
  networking.firewall.enable = true;
}
