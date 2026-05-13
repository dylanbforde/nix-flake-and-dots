{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = ../../wallpapers/background_wallpaper.jpg;
in
{
  assertions = [
    {
      assertion =
        !(
          config.systemd.user.services ? niri && config.systemd.user.services.niri.serviceConfig ? ExecStart
        );
      message = ''
        Do not override niri's upstream systemd user ExecStart.
        Put niri behavior in ~/.config/niri/config.kdl instead.
      '';
    }
  ];

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

  # Let niri inherit the full environment imported by niri-session instead of a
  # stripped systemd default PATH.
  systemd.user.services.niri.enableDefaultPath = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
      common.default = [ "gtk" ];
    };
  };

  environment.systemPackages = with pkgs; [
    cliphist
    grim
    xwayland-satellite
    networkmanagerapplet
    mako
    slurp
    swayidle
    swaylock
    waybar
    wofi
    wl-clipboard
    libnotify
    brightnessctl
    playerctl
    psmisc
    qt6.qtwayland
    swaybg
    kitty
  ];

  security.pam.services.swaylock = { };

  home-manager.users.dylan =
    { config, ... }:
    {
      xdg.configFile = {
        "swaylock/config".text =
          let
            c = config.theme.palette;
            strip = hex: pkgs.lib.strings.removePrefix "#" hex;
          in
          ''
            color=${strip c.base}
            inside-color=${strip c.surface0}cc
            ring-color=${strip c.mauve}
            key-hl-color=${strip c.teal}
            text-color=${strip c.text}
            line-color=${strip c.base}
            separator-color=${strip c.surface1}
            indicator-radius=120
            indicator-thickness=8
            show-failed-attempts
          '';

        "waybar/config".text = ''
          {
            "layer": "top",
            "position": "top",
            "exclusive": true,
            "modules-left": ["niri/workspaces"],
            "modules-center": ["clock"],
            "modules-right": ["tray", "cpu", "memory", "backlight", "network", "pulseaudio", "battery"],
            "niri/workspaces": {
              "format": "{name}"
            },
            "tray": {
              "icon-size": 13,
              "spacing": 10
            },
            "clock": {
              "format": "{:%H:%M  %e %b}",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
            },
            "backlight": {
              "format": "BL {percent}%"
            },
            "battery": {
              "states": {
                "good": 95,
                "warning": 30,
                "critical": 15
              },
              "format": "BAT {capacity}%",
              "format-charging": "BAT+ {capacity}%",
              "format-plugged": "AC {capacity}%"
            },
            "network": {
              "format-wifi": "NET {essid}",
              "format-ethernet": "LAN {ipaddr}/{cidr}",
              "format-disconnected": "NET down"
            },
            "pulseaudio": {
              "format": "VOL {volume}%",
              "format-muted": "VOL muted",
              "on-click": "pavucontrol"
            },
            "cpu": {
              "interval": 10,
              "format": "CPU {usage}%"
            },
            "memory": {
              "interval": 30,
              "format": "MEM {}%"
            }
          }
        '';

        "waybar/style.css".text =
          let
            c = config.theme.palette;
          in
          ''
            * {
                font-family: "JetBrainsMono Nerd Font", monospace;
                font-size: 13px;
                min-height: 0;
            }

            window#waybar {
                background: transparent;
                color: ${c.text};
            }

            #workspaces {
                background: ${c.base};
                margin: 0 4px;
                padding: 0 5px;
                border: 1px solid ${c.crust};
            }

            #workspaces button {
                padding: 0 7px;
                background: transparent;
                color: ${c.text};
                border-radius: 0;
            }

            #workspaces button.active {
                color: ${c.mauve};
            }

            #clock, #battery, #cpu, #memory, #backlight, #network, #pulseaudio, #tray {
                padding: 0 10px;
                margin: 0 4px;
                color: ${c.crust};
                font-weight: bold;
            }

            #clock { background: ${c.mauve}; }
            #battery { background: ${c.green}; }
            #battery.charging { background: ${c.teal}; }
            #battery.warning { background: ${c.yellow}; }
            #battery.critical { background: ${c.red}; }
            #network { background: ${c.blue}; }
            #pulseaudio { background: ${c.pink}; }
            #cpu { background: ${c.peach}; }
            #memory { background: ${c.yellow}; }
            #backlight { background: ${c.teal}; }
            #tray {
                background: ${c.base};
                color: ${c.text};
            }
          '';

        "niri/config.kdl" = {
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

            window-rule {
              match app-id="kitty"
              draw-border-with-background false
            }

            environment {
              QT_QPA_PLATFORM "wayland"
              ELECTRON_OZONE_PLATFORM_HINT "auto"
            }

            spawn-at-startup "${pkgs.networkmanagerapplet}/bin/nm-applet"
            spawn-at-startup "${pkgs.mako}/bin/mako"
            spawn-at-startup "${pkgs.waybar}/bin/waybar"
            spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${wallpaper}" "-m" "fill"
            spawn-at-startup "${pkgs.swayidle}/bin/swayidle" "-w" "timeout" "600" "${pkgs.swaylock}/bin/swaylock -f" "timeout" "1800" "${pkgs.systemd}/bin/systemctl suspend" "before-sleep" "${pkgs.swaylock}/bin/swaylock -f"
            spawn-at-startup "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "text" "--watch" "${pkgs.cliphist}/bin/cliphist" "store"
            spawn-at-startup "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "image" "--watch" "${pkgs.cliphist}/bin/cliphist" "store"

            binds {
              Mod+Return { spawn "${pkgs.kitty}/bin/kitty"; }
              Mod+D { spawn "${pkgs.wofi}/bin/wofi" "--show" "drun"; }
              Mod+B { spawn "${pkgs.brave}/bin/brave"; }
              Mod+E { spawn "${pkgs.xfce.thunar}/bin/thunar"; }
              Mod+T { spawn "${pkgs.kitty}/bin/kitty" "-e" "${pkgs.btop}/bin/btop"; }
              Mod+M { spawn "${pkgs.spotify}/bin/spotify"; }
              Mod+N { spawn "${pkgs.unstable.antigravity}/bin/antigravity"; }
              Mod+L { spawn "${pkgs.swaylock}/bin/swaylock" "-f"; }
              Mod+C { spawn "${pkgs.bash}/bin/sh" "-c" "${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"; }
              Mod+Q { close-window; }
              Mod+Shift+E { quit; }
              Mod+F { fullscreen-window; }
              Mod+Left { focus-column-left; }
              Mod+Right { focus-column-right; }
              Mod+Shift+Left { move-column-left; }
              Mod+Shift+Right { move-column-right; }
              Mod+Up { focus-window-up; }
              Mod+Down { focus-window-down; }
              Mod+Page_Down { focus-workspace-down; }
              Mod+Page_Up { focus-workspace-up; }
              Mod+Shift+Page_Down { move-column-to-workspace-down; }
              Mod+Shift+Page_Up { move-column-to-workspace-up; }
              Mod+R { switch-preset-column-width; }
              Mod+Shift+F { maximize-column; }
              Mod+BracketLeft { consume-or-expel-window-left; }
              Mod+BracketRight { consume-or-expel-window-right; }
              Mod+V { toggle-window-floating; }
              Mod+Shift+V { switch-focus-between-floating-and-tiling; }
              Mod+Space { toggle-overview; }
              Print { screenshot; }
              Mod+Print { spawn "${pkgs.bash}/bin/sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"; }
              XF86AudioRaiseVolume allow-when-locked=true { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
              XF86AudioLowerVolume allow-when-locked=true { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
              XF86AudioMute allow-when-locked=true { spawn "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
              XF86MonBrightnessUp allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "+5%"; }
              XF86MonBrightnessDown allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"; }
            }
          '';
        };
      };
    };
}
