{ config, inputs, lib, pkgs, ... }:

let
  niriConfig = pkgs.writeText "niri-config.kdl" config.home-manager.users.dylan.xdg.configFile."niri/config.kdl".text;
  dms = "${inputs.dms.packages.${pkgs.system}.default}/bin/dms";
  kitty = "${pkgs.kitty}/bin/kitty";
  wallpaper = ../../wallpapers/background_wallpaper.jpg;
in
{
  services.displayManager.ly.enable = true;

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  programs.dconf.enable = true;

  systemd.user.services.niri.serviceConfig.ExecStart =
    lib.mkForce "${pkgs.niri}/bin/niri --session -c ${niriConfig}";

  security.pam.services.quickshell = {};

  environment.sessionVariables = {
    NIRI_CONFIG = "${niriConfig}";
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
  ];

  home-manager.users.dylan = { config, ... }: {
    imports = [
      inputs.dms.homeModules.dank-material-shell
    ];

    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgs.unstable.dgop;

      systemd = {
        enable = false;
        restartIfChanged = true;
      };

      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = false;
      enableAudioWavelength = true;
      enableCalendarEvents = false;
      enableClipboardPaste = true;

      settings = {
        theme = "dark";
        dynamicTheming = false;
      };

      session = {
        isLightMode = false;
      };

      clipboardSettings = {
        maxHistory = 50;
        disabled = false;
        disableHistory = false;
        disablePersist = false;
      };
    };

    xdg.configFile."niri/config.kdl" = {
      force = true;
      text = let
        c = config.theme.palette;
      in ''
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

          focus-ring {
              width 2
              active-color "${c.mauve}"
              inactive-color "${c.surface1}"
          }

          border {
              off
          }

          shadow {
              on
              softness 30
              spread 5
              offset x=0 y=5
              color "#0007"
          }
      }

      spawn-at-startup "${pkgs.networkmanagerapplet}/bin/nm-applet"
      spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${wallpaper}" "-m" "fill"
      spawn-at-startup "${dms}" "run"

      environment {
          XDG_CURRENT_DESKTOP "niri"
          QT_QPA_PLATFORM "wayland"
          ELECTRON_OZONE_PLATFORM_HINT "auto"
      }

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      hotkey-overlay {
          skip-at-startup
      }

      layer-rule {
          match namespace="^quickshell$"
          place-within-backdrop true
      }

      layer-rule {
          match namespace="dms:blurwallpaper"
          place-within-backdrop true
      }

      window-rule {
          match app-id=r#"^org\.quickshell$"#
          open-floating true
      }

      window-rule {
          match app-id=r#"^org\.gnome\."#
          draw-border-with-background false
          geometry-corner-radius 12
          clip-to-geometry true
      }

      window-rule {
          match app-id="kitty"
          draw-border-with-background false
      }

      window-rule {
          match is-active=false
          opacity 0.92
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Escape { toggle-keyboard-shortcuts-inhibit; }
          Ctrl+Alt+Delete { quit; }

          Mod+Return hotkey-overlay-title="Open Terminal" { spawn "${kitty}"; }
          Mod+T hotkey-overlay-title="Open Terminal" { spawn "${kitty}"; }

          Mod+Space hotkey-overlay-title="Application Launcher" {
              spawn "${dms}" "ipc" "call" "spotlight" "toggle";
          }

          Mod+V hotkey-overlay-title="Clipboard Manager" {
              spawn "${dms}" "ipc" "call" "clipboard" "toggle";
          }

          Mod+M hotkey-overlay-title="Task Manager" {
              spawn "${dms}" "ipc" "call" "processlist" "focusOrToggle";
          }

          Mod+Comma hotkey-overlay-title="Settings" {
              spawn "${dms}" "ipc" "call" "settings" "focusOrToggle";
          }

          Mod+N hotkey-overlay-title="Notification Center" {
              spawn "${dms}" "ipc" "call" "notifications" "toggle";
          }

          Mod+Y hotkey-overlay-title="Browse Wallpapers" {
              spawn "${dms}" "ipc" "call" "dankdash" "wallpaper";
          }

          Mod+Alt+L allow-inhibiting=false hotkey-overlay-title="Lock Screen" {
              spawn "${dms}" "ipc" "call" "lock" "lock";
          }

          XF86AudioRaiseVolume allow-when-locked=true {
              spawn "${dms}" "ipc" "call" "audio" "increment" "3";
          }

          XF86AudioLowerVolume allow-when-locked=true {
              spawn "${dms}" "ipc" "call" "audio" "decrement" "3";
          }

          XF86AudioMute allow-when-locked=true {
              spawn "${dms}" "ipc" "call" "audio" "mute";
          }

          XF86MonBrightnessUp allow-when-locked=true {
              spawn "${dms}" "ipc" "call" "brightness" "increment" "5" "";
          }

          XF86MonBrightnessDown allow-when-locked=true {
              spawn "${dms}" "ipc" "call" "brightness" "decrement" "5" "";
          }

          XF86AudioPlay allow-when-locked=true { spawn "${pkgs.playerctl}/bin/playerctl" "play-pause"; }
          XF86AudioStop allow-when-locked=true { spawn "${pkgs.playerctl}/bin/playerctl" "stop"; }
          XF86AudioPrev allow-when-locked=true { spawn "${pkgs.playerctl}/bin/playerctl" "previous"; }
          XF86AudioNext allow-when-locked=true { spawn "${pkgs.playerctl}/bin/playerctl" "next"; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          Mod+O repeat=false { toggle-overview; }
          Mod+Q repeat=false { close-window; }
          Mod+F { fullscreen-window; }
          Mod+W { toggle-column-tabbed-display; }

          Mod+Left { focus-column-left; }
          Mod+Down { focus-window-down; }
          Mod+Up { focus-window-up; }
          Mod+Right { focus-column-right; }
          Mod+H { focus-column-left; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+L { focus-column-right; }

          Mod+Ctrl+Left { move-column-left; }
          Mod+Ctrl+Down { move-window-down; }
          Mod+Ctrl+Up { move-window-up; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+H { move-column-left; }
          Mod+Ctrl+J { move-window-down; }
          Mod+Ctrl+K { move-window-up; }
          Mod+Ctrl+L { move-column-right; }

          Mod+Home { focus-column-first; }
          Mod+End { focus-column-last; }
          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End { move-column-to-last; }

          Mod+Shift+Left { focus-monitor-left; }
          Mod+Shift+Down { focus-monitor-down; }
          Mod+Shift+Up { focus-monitor-up; }
          Mod+Shift+Right { focus-monitor-right; }
          Mod+Shift+H { focus-monitor-left; }
          Mod+Shift+J { focus-monitor-down; }
          Mod+Shift+K { focus-monitor-up; }
          Mod+Shift+L { focus-monitor-right; }

          Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }
          Mod+0 { focus-workspace 10; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }
          Mod+Ctrl+0 { move-column-to-workspace 10; }

          Mod+BracketLeft { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }
          Mod+Period { expel-window-from-column; }
          Mod+R { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
      }
    '';
    };
  };
}
