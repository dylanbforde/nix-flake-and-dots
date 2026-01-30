{ config, pkgs, ... }:

{
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };
  
  # Desktop/Hyprland specific packages
  environment.systemPackages = with pkgs; [
    kitty
    waybar
    wofi
    hyprpaper
    networkmanagerapplet
    wl-clipboard
    grim
    slurp
    swaylock
    dunst
    libnotify
  ];

  # Allow Home Manager to manage these files, but define them here for organization
  # Note: This requires Home Manager to be active
  home-manager.users.dylan = {
    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    xdg.configFile."waybar/config".source = ./waybar-config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar-style.css;
    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    xdg.configFile."hypr/hyperApps.conf".source = ./hyperApps.conf;
  };
}
