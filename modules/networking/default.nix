{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Security: explicitly define firewall state to ensure intended security posture
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
