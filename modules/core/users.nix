{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # Removed "docker" group to enforce rootless docker usage and prevent privilege escalation
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
