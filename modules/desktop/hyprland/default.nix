{ config, pkgs, ... }:

{
  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Allow hyprlock to unlock the screen
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  



  imports = [
    ./keyshelf.nix
  ];

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
    hypridle
    hyprlock
    dunst
    libnotify
    psmisc
  ];

  # Home Manager Config
  home-manager.users.dylan = { config, ... }: {
    xdg.configFile."hypr/hyprpaper.conf".text = let
      wp = config.theme.wallpaper;
    in ''
      preload = ${wp}
      wallpaper = ,${wp}
    '';

    xdg.configFile."hypr/hypridle.conf".text = if config.theme.screensaver then ''
      general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }

      listener {
          timeout = 300                                # 5min.
          on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = brightnessctl -r                 # monitor backlight restore.
      }

      listener {
          timeout = 720                                 # 12min
          on-timeout = loginctl lock-session            # lock screen when timeout has passed
      }

      listener {
          timeout = 900                                 # 15min
          on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
          on-resume = hyprctl dispatch dpms on          # screen on when activity is detected
      }

      listener {
          timeout = 1800                                # 30min
          on-timeout = systemctl suspend                # suspend pc
      }
    '' else ''
      general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }
    '';

    xdg.configFile."hypr/hyprlock.conf".text = let
      t = config.theme;
      c = t.palette;
      strip = hex: pkgs.lib.strings.removePrefix "#" hex;
    in ''
      general {
          no_fade_in = false
          grace = 0
          disable_loading_bar = true
      }

      background {
          monitor =
          path = ${t.wallpaper}
          color = rgba(25, 20, 20, 1.0)
          blur_passes = 2
          blur_size = 7
      }

      input-field {
          monitor =
          size = 200, 50
          outline_thickness = 3
          dots_size = 0.33
          dots_spacing = 0.15
          dots_center = true
          outer_color = rgb(${strip c.mauve})
          inner_color = rgb(${strip c.base})
          font_color = rgb(${strip c.text})
          fade_on_empty = true
          placeholder_text = <i>Password...</i>
          hide_input = false
          position = 0, -20
          halign = center
          valign = center
      }

      label {
          monitor =
          text = $TIME
          color = rgb(${strip c.text})
          font_size = 64
          font_family = JetBrains Mono Nerd Font
          position = 0, 80
          halign = center
          valign = center
      }
    '';
    
    xdg.configFile."hypr/hyprland.conf".text = let
      t = config.theme;
      c = t.palette;
      # Strip # for hyprland rgb() wrapper
      strip = hex: pkgs.lib.strings.removePrefix "#" hex;
      # Helper for glassy borders
      border_color = if t.glass then "rgba(${strip c.mauve}cc)" else "rgb(${strip c.mauve})";
    in ''
      # Templated Hyprland Config
      
      monitor=,preferred,auto,1

      exec-once = hyprpaper &
      exec-once = hypridle &
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
              size = ${if t.glass then "6" else "6"}
              passes = ${if t.glass then "3" else "3"}
              new_optimizations = true
              vibrancy = ${if t.glass then "0.20" else "0.0"}
              noise = ${if t.glass then "0.01" else "0.0"}
          }
          shadow {
              enabled = true
              range = ${if t.glass then "20" else "4"}
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
      bind = $mod, L, exec, hyprlock
      bind = $mod, B, exec, brave
      bind = $mod, W, killactive, 
      bind = $mod, F, fullscreen, 
      bind = $mod, G, togglegroup
      bind = $mod, Tab, changegroupactive
      bind = $mod, S, togglespecialworkspace, magic
      bind = $mod SHIFT, S, movetoworkspace, special:magic

      # Screenshots
      bind = , Print, exec, grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Screenshot saved"
      bind = $mod, Print, exec, grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Screenshot saved"
      
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

      # Move active window to a workspace with mod + SHIFT + [0-9]
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
      bind = $mod SHIFT, 0, movetoworkspace, 10

      # Move window with mod + SHIFT + arrow keys
      bind = $mod SHIFT, left, movewindow, l
      bind = $mod SHIFT, right, movewindow, r
      bind = $mod SHIFT, up, movewindow, u
      bind = $mod SHIFT, down, movewindow, d

      # Resize window with mod + CTRL + arrow keys
      bind = $mod CTRL, left, resizeactive, -20 0
      bind = $mod CTRL, right, resizeactive, 20 0
      bind = $mod CTRL, up, resizeactive, 0 -20
      bind = $mod CTRL, down, resizeactive, 0 20

      # Volume/Brightness
      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86MonBrightnessUp, exec, brightnessctl set +5%
      bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

      ${if t.glass then ''
      # Layer rules for glass effect
      layerrule = blur, waybar
      layerrule = ignorealpha 0.4, waybar
      layerrule = blur, wofi
      layerrule = ignorealpha 0.4, wofi

      # Window rules for app-specific opacity (active inactive)
      windowrulev2 = opacity 0.70 0.60, class:^(kitty)$
      windowrulev2 = opacity 0.85 0.80, class:^(Code)$
      windowrulev2 = opacity 0.85 0.80, class:^(brave-browser)$
      windowrulev2 = opacity 0.85 0.80, class:^(Brave-browser)$
      windowrulev2 = opacity 0.85 0.80, class:^(chromium)$
      windowrulev2 = opacity 0.85 0.80, class:^(thunar)$
      windowrulev2 = opacity 0.80 0.75, class:^(org.gnome.Nautilus)$
      '' else ""}
    '';
  };
}
