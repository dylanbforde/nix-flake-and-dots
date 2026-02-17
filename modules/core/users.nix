{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # Sentinel: Removed "docker" group to prevent privilege escalation.
    # Rootless docker is enabled via virtualisation.docker.rootless.enable = true
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
