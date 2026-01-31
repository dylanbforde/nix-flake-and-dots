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

  # Home Manager Config
  home-manager.users.dylan = {
    xdg.configFile."hypr/hyprpaper.conf".text = let
      wp = config.home-manager.users.dylan.theme.wallpaper;
    in ''
      preload = ${wp}
      wallpaper = ,${wp}
    '';
    
    xdg.configFile."hypr/hyprland.conf".text = let
      t = config.home-manager.users.dylan.theme;
      c = t.palette;
      # Strip # for hyprland rgb() wrapper
      strip = hex: pkgs.lib.strings.removePrefix "#" hex;
      # Helper for glassy borders
      border_color = if t.glass then "rgba(${strip c.mauve}cc)" else "rgb(${strip c.mauve})";
    in ''
      # Templated Hyprland Config
      
      monitor=,preferred,auto,1

      exec-once = hyprpaper &
      exec-once = waybar &
      exec-once = nm-applet &
      exec-once = dunst &

      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = ${border_color} rgb(${strip c.teal}) 45deg
          col.inactive_border = rgb(${strip c.surface1})
          layout = dwindle
      }

      decoration {
          rounding = 0
          active_opacity = ${toString t.opacity}
          inactive_opacity = ${toString (t.opacity - 0.1)}
          
          blur {
              enabled = true
              size = 6
              passes = 3
              new_optimizations = true
          }
          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }
      }

      animations {
          enabled = yes
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      $mod = SUPER

      # Binds
      bind = $mod, RETURN, exec, kitty
      bind = $mod, D, exec, wofi --show drun
      bind = $mod, W, killactive, 
      bind = $mod, F, fullscreen, 
      bind = $mod, G, togglegroup
      bind = $mod, Tab, changegroupactive
      bind = $mod, S, togglespecialworkspace, magic
      bind = $mod SHIFT, S, movetoworkspace, special:magic
      
      # Arrows
      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d
      
      # Workspaces
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      # Volume/Brightness
      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86MonBrightnessUp, exec, brightnessctl set +5%
      bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
    '';
  };
}
