{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Explicitly define firewall state as a defense-in-depth measure
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
}
