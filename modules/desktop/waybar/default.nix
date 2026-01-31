{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar
  ];

  # Home Manager Config
  home-manager.users.dylan = { config, ... }: {
    xdg.configFile."waybar/config".source = ./config.jsonc;
    xdg.configFile."waybar/style.css".text = let
      c = config.theme.palette;
      t = config.theme;
      # Helper to convert hex to rgba for glass effect
      hexToRgba = hex: alpha: let
        r = pkgs.lib.toInt "0x${builtins.substring 1 2 hex}";
        g = pkgs.lib.toInt "0x${builtins.substring 3 2 hex}";
        b = pkgs.lib.toInt "0x${builtins.substring 5 2 hex}";
      in "rgba(${toString r}, ${toString g}, ${toString b}, ${alpha})";
      # Glass-aware background
      baseBg = if t.glass then hexToRgba c.base "0.75" else c.base;
      moduleBg = alpha: color: if t.glass then hexToRgba color alpha else color;
    in ''
      /* Templated Candy Bar Style */
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
          background: ${baseBg};
          margin: 0 4px;
          padding: 0 5px;
          border-radius: 0px;
          border: 1px solid ${if t.glass then c.teal else c.crust};
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: ${c.text};
      }

      #workspaces button.active {
          color: ${c.mauve};
      }

      #workspaces button:hover {
          background: ${if t.glass then hexToRgba c.surface1 "0.5" else c.surface1};
      }

      #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #tray {
          padding: 0 10px;
          margin: 0 4px;
          color: ${if t.glass then c.text else c.crust};
          font-weight: bold;
      }

      #clock { background: ${moduleBg "0.85" c.mauve}; }
      #battery { background: ${moduleBg "0.85" c.green}; }
      #battery.charging { background: ${moduleBg "0.85" c.teal}; }
      #battery.warning { background: ${moduleBg "0.85" c.yellow}; }
      #battery.critical { background: ${moduleBg "0.85" c.red}; }
      #network { background: ${moduleBg "0.85" c.blue}; }
      #pulseaudio { background: ${moduleBg "0.85" c.pink}; }
      #cpu { background: ${moduleBg "0.85" c.peach}; }
      #memory { background: ${moduleBg "0.85" c.yellow}; }
      #temperature { background: ${moduleBg "0.85" c.maroon}; }
      #backlight { background: ${moduleBg "0.85" c.teal}; }
      
      #tray {
          background: ${baseBg};
          color: ${c.text};
      }
    '';
  };
}
