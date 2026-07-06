{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Security: explicitly define firewall state to ensure intended security posture
  networking.firewall.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
