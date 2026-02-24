{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # Removed "docker" group to prevent privilege escalation.
    # Rootless docker is enabled in modules/programs/dev.nix and should be used instead.
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
