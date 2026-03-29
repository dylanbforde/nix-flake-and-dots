{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Defense-in-depth: Ensure firewall is explicitly enabled
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
