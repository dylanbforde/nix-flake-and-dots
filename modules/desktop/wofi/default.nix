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
    in ''
      /* Templated Wofi Style */
      @define-color base ${c.base};
      @define-color text ${c.text};
      @define-color mauve ${c.mauve};
      @define-color surface ${c.surface0};
      @define-color overlay ${c.surface1};

      window {
          margin: 0px;
          border: 2px solid @mauve;
          background-color: @base;
          border-radius: 10px;
      }

      #input {
          margin: 5px;
          border-radius: 5px;
          border: none;
          background-color: @surface;
          color: @text;
          padding: 5px;
      }

      #text {
          margin: 5px;
          border: none;
          color: @text;
      }

      #entry:selected {
          background-color: @overlay;
          border-radius: 5px;
      }

      #entry:selected #text {
          color: @mauve;
          font-weight: bold;
      }
    '';
  };
}
