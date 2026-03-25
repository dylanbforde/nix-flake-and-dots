{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # explicitly define firewall instead of relying on defaults
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
