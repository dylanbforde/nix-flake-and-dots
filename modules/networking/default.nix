{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Explicit firewall enable (defense in depth)
  networking.firewall.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
}
