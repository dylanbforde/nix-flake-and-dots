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
    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  };
}
