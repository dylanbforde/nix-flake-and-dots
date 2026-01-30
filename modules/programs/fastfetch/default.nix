{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
