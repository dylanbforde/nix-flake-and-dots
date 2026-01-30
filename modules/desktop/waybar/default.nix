{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."waybar/config".source = ./config.jsonc;
    xdg.configFile."waybar/style.css".source = ./style.css;
  };
}
