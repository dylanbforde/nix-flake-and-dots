{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Explicitly enable firewall for defense-in-depth rather than relying on defaults
  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
