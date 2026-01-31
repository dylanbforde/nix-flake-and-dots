{ config, pkgs, ... }:

{
  # Theme Setup Options
  options.theme = {
    palette = pkgs.lib.mkOption {
      type = pkgs.lib.types.attrs;
      default = (import ../theme/palettes.nix).mocha;
    };
    wallpaper = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "/home/dylan/wallpapers/vaporwave.png";
    };
  };

  config = {
    home.username = "dylan";
    home.homeDirectory = "/home/dylan";

    # Home Manager Settings
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    # Specialisation for Theme Switching
    specialisation."oil-painting".configuration = {
      theme.palette = (import ../theme/palettes.nix).oil_painting;
      theme.wallpaper = pkgs.lib.mkForce "/home/dylan/wallpapers/oil-painting.jpg";
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
      bashrcExtra = ''
        if command -v zoxide >/dev/null 2>&1; then
         eval "$(zoxide init bash)"
        fi
        if command -v eza >/dev/null 2>&1; then
         alias ls='eza --icons=auto --group-directories-first'
         alias ll='eza -la --icons=auto --group-directories-first'
        fi

        # Distrobox Helpers
        db-cuda() {
          local name="cuda-$(basename "$PWD")"
          if ! distrobox list | grep -q "$name"; then
            echo "Creating CUDA container: $name"
            distrobox create -Y -n "$name" --image nvidia/cuda:12.4.1-devel-ubuntu22.04 --nvidia --home "$PWD"
          fi
          distrobox enter "$name"
        }

        db-ubuntu() {
          local name="ubuntu-$(basename "$PWD")"
          if ! distrobox list | grep -q "$name"; then
            echo "Creating Ubuntu container: $name"
            distrobox create -Y -n "$name" --image ubuntu:22.04 --home "$PWD"
          fi
          distrobox enter "$name"
        }

        # Theme Switcher Helper
        theme-switch() {
          local name="$1"
          local base_path="$HOME/.local/state/nix/profiles/home-manager/specialisation"
          if [ -z "$name" ]; then
            echo "Switching to default theme..."
            # To go back to base, we just activate the main HM profile
            "$HOME/.local/state/nix/profiles/home-manager/activate"
          elif [ -d "$base_path/$name" ]; then
            echo "Switching to theme: $name"
            "$base_path/$name/activate"
          else
            echo "Theme '$name' not found. Available themes:"
            ls "$base_path"
          fi
        }
      '';
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
  };
}
