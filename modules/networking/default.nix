{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
  };

  # Explicitly enable firewall
  networking.firewall.enable = true;
}
