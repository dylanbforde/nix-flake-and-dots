{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Defense in depth: explicit firewall boundary rather than relying on defaults
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
