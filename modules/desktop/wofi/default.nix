{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wofi
  ];

  # Home Manager Config
  home-manager.users.dylan = { config, ... }: {
    xdg.configFile."wofi/config".source = ./config;
    xdg.configFile."wofi/style.css".text = let
      c = config.theme.palette;
      t = config.theme;
      # Helper to convert hex to rgba for glass effect
      hexToRgba = hex: alpha: let
        r = pkgs.lib.toInt "0x${builtins.substring 1 2 hex}";
        g = pkgs.lib.toInt "0x${builtins.substring 3 2 hex}";
        b = pkgs.lib.toInt "0x${builtins.substring 5 2 hex}";
      in "rgba(${toString r}, ${toString g}, ${toString b}, ${alpha})";
      # Glass-aware colors
      baseBg = if t.glass then hexToRgba c.base "0.80" else c.base;
      surfaceBg = if t.glass then hexToRgba c.surface0 "0.70" else c.surface0;
      overlayBg = if t.glass then hexToRgba c.surface1 "0.80" else c.surface1;
    in ''
      /* Templated Wofi Style */
      @define-color base ${c.base};
      @define-color text ${c.text};
      @define-color mauve ${c.mauve};
      @define-color surface ${c.surface0};
      @define-color overlay ${c.surface1};

      window {
          margin: 0px;
          border: 2px solid ${if t.glass then c.teal else "@mauve"};
          background-color: ${baseBg};
          border-radius: 10px;
      }

      #input {
          margin: 5px;
          border-radius: 5px;
          border: none;
          background-color: ${surfaceBg};
          color: @text;
          padding: 5px;
      }

      #text {
          margin: 5px;
          border: none;
          color: @text;
      }

      #entry:selected {
          background-color: ${overlayBg};
          border-radius: 5px;
      }

      #entry:selected #text {
          color: @mauve;
          font-weight: bold;
      }
    '';
  };
}
