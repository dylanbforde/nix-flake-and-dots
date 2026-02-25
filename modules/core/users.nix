{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    extraGroups = [ "networkmanager" "wheel" ]; # Security: Use rootless docker
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
