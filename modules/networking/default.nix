{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Security Hardening
  services.openssh.settings.PermitRootLogin = "no";
  networking.firewall.enable = true;
}
