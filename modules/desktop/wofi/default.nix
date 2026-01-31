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
      # Helper to convert a single hex char to int
      hexCharToInt = ch:
        if ch == "0" then 0 else if ch == "1" then 1 else if ch == "2" then 2
        else if ch == "3" then 3 else if ch == "4" then 4 else if ch == "5" then 5
        else if ch == "6" then 6 else if ch == "7" then 7 else if ch == "8" then 8
        else if ch == "9" then 9 else if ch == "a" || ch == "A" then 10
        else if ch == "b" || ch == "B" then 11 else if ch == "c" || ch == "C" then 12
        else if ch == "d" || ch == "D" then 13 else if ch == "e" || ch == "E" then 14
        else if ch == "f" || ch == "F" then 15 else 0;
      # Convert two hex chars to int (0-255)
      hexPairToInt = s: (hexCharToInt (builtins.substring 0 1 s)) * 16 + (hexCharToInt (builtins.substring 1 1 s));
      # Helper to convert hex color to rgba
      hexToRgba = hex: alpha: let
        r = hexPairToInt (builtins.substring 1 2 hex);
        g = hexPairToInt (builtins.substring 3 2 hex);
        b = hexPairToInt (builtins.substring 5 2 hex);
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
