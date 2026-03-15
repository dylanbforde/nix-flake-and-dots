{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Defense in depth: explicitly enable firewall so we don't rely on OS defaults
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Defense in depth: explicitly disable password auth to prevent brute force attacks
  services.openssh.settings.PasswordAuthentication = false;
}
