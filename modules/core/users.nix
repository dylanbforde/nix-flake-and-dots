{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # Rootless docker is enabled, do not add to docker group to prevent privilege escalation
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
