{ config, lib, pkgs, ... }:

let
  wallpaper = ../../wallpapers/background_wallpaper.jpg;
in
{
  services.displayManager = {
    ly.enable = true;
    defaultSession = lib.mkDefault "niri";
  };

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # Keep a fallback session in Ly while stabilizing Niri.
  programs.hyprland.enable = true;

  programs.dconf.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      common.default = [ "gtk" ];
    };
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    networkmanagerapplet
    wl-clipboard
    libnotify
    brightnessctl
    playerctl
    psmisc
    qt6.qtwayland
    swaybg
    kitty
  ];

  home-manager.users.dylan = { ... }: {
    xdg.configFile."niri/config.kdl" = {
      force = true;
      text = ''
        input {
          keyboard {
            xkb {}
            numlock
          }

          touchpad {
            tap
            natural-scroll
          }
        }

        output "eDP-1" {
          scale 1
        }

        layout {
          gaps 8
          background-color "transparent"
        }

        spawn-at-startup "${pkgs.networkmanagerapplet}/bin/nm-applet"
        spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${wallpaper}" "-m" "fill"

        binds {
          Mod+Return { spawn "${pkgs.kitty}/bin/kitty"; }
          Mod+Q { close-window; }
          Mod+Shift+E { quit; }
          Mod+F { fullscreen-window; }
          Mod+Left { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up { focus-window-up; }
          Mod+Down { focus-window-down; }
          Print { screenshot; }
        }
      '';
    };
  };
}
