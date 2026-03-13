{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false; # Sentinel: explicit secure default

  # Sentinel: explicit firewall boundary
  networking.firewall.enable = true;
}
