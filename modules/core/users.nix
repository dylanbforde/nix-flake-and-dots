{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
