{ config, pkgs, lib, ... }:

{
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  # Home Manager Settings
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # Expose wallpapers to home directory for easy cycling
  home.file."wallpapers".source = ../wallpapers;

  # Specialisation for Theme Switching
  specialisation."oil-painting".configuration = {
    theme.palette = (import ../theme/palettes.nix).oil_painting;
    theme.wallpaper = pkgs.lib.mkForce ../wallpapers/claude-monet-le-grand-canal-et-santa-maria-della-salute.jpg;
    theme.opacity = 0.95;
    theme.glass = true;
  };

  # Cursor Theme
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Programs customized via Home Manager
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc.sh;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        mouse = false;
        lsp.display-messages = true;
      };
    };
    languages = {
      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
          config = {
            checkOnSave = {
              command = "clippy";
            };
          };
        };
        nil = {
          command = "nil";
        };
      };
      language = [
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [ "ty" ];
        }
        {
          name = "nix";
          language-servers = [ "nil" ];
        }
      ];
    };
  };
  
  # Starship Shell Prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "$directory$character";
      right_format = "$all";
      add_newline = false;
      
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };

      directory = {
        style = "bold lavender";
        format = "[$path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
      };

      package = {
        symbol = " ";
        style = "bold yellow";
        format = "[$symbol$version]($style) ";
      };

      golang = {
        symbol = " ";
        style = "bold blue";
      };

      rust = {
        symbol = " ";
        style = "bold red";
      };
      
      python = {
        symbol = "🐍 ";
        style = "bold yellow";
      };
    };
  };
}
