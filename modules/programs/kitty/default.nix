{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
  ];

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
  };
}
