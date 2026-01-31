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
          background: ${c.base};
          margin: 0 4px;
          padding: 0 5px;
          border-radius: 0px;
          border: 1px solid ${c.crust};
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
          background: ${c.surface1};
      }

      #clock, #battery, #cpu, #memory, #temperature, #backlight, #network, #pulseaudio, #tray {
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
      #temperature { background: ${c.maroon}; }
      #backlight { background: ${c.teal}; }
      
      #tray {
          background: ${c.base};
          color: ${c.text};
      }
    '';
  };
}
