{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # Sentinel: Removed "docker" group to prevent implicit root access.
    # Use rootless docker (configured in dev.nix) or sudo for system daemon.
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
