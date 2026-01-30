{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wofi
  ];

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."wofi/config".source = ./config;
    xdg.configFile."wofi/style.css".source = ./style.css;
  };
}
