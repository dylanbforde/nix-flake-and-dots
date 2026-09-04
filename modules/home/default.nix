{
  config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    username = "dylan";
    homeDirectory = "/home/dylan";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    stateVersion = "25.05";
    file."wallpapers".source = ../wallpapers;
    pointerCursor = {
      name = lib.mkDefault "Bibata-Modern-Classic";
      package = lib.mkDefault pkgs.bibata-cursors;
      size = lib.mkDefault 24;
      gtk.enable = lib.mkDefault true;
      x11.enable = lib.mkDefault true;
    };
  };

  # Modern CLI Tools
  programs = {
    home-manager.enable = true;
    zoxide.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--margin=1"
        "--padding=1"
      ];
    };
    bat.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = lib.mkDefault "catppuccin_mocha";
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
          ty = {
            command = "ty";
            args = [ "server" ];
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
    starship = {
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
  };
}
