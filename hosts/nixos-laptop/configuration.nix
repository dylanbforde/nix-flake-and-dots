# /home/dylan/nixos-config/hosts/nixos-laptop/configuration.nix
{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core/default.nix
    ../../modules/hardware/tablet.nix
    ../../modules/networking/default.nix
    ../../modules/programs/common.nix
    ../../modules/programs/dev.nix
    ../../modules/programs/shell.nix
    ../../modules/security/default.nix
    ../../modules/programs/kitty/default.nix
    ../../modules/desktop/niri/default.nix
    ../../modules/programs/fastfetch/default.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  services = {
    tlp.enable = true;
    thermald.enable = true;
  };

  # Keep long-running local work reachable unless the user explicitly locks or
  # suspends the machine.
  home-manager.users.dylan.theme.screensaver = false;
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
    IdleAction = "ignore";
  };

  networking.hostName = "nixos-laptop";
  system.stateVersion = "25.05";
}
