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
    theme.wallpaper = pkgs.lib.mkForce ../wallpapers/oil_painting_ruins.jpg;
    theme.opacity = 0.85;
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

      # Advanced Theme Switcher
      theme-switch() {
        local cmd="$1"
        local wp_path="$HOME/wallpapers"
        
        local hm_base="$HOME/.local/state/nix/profiles/home-manager"
        local main_activate="$hm_base/activate"
        local spec_base="$hm_base/specialisation"
        local active_file="$HOME/.theme_oil_active"

        case "$cmd" in
          palette)
            if [ ! -f "$active_file" ]; then
              if [ -d "$spec_base/oil-painting" ]; then
                echo "🎨 Switching to Oil Painting palette..."
                touch "$active_file"
                "$spec_base/oil-painting/activate"
              else
                echo "❌ Specialisation 'oil-painting' not found!"
                return 1
              fi
            else
              echo "🎨 Switching to Vaporwave (Base) palette..."
              rm -f "$active_file"
              "$main_activate"
            fi
            
            # Post-switch reloads
            echo "🔄 Refreshing applications..."
            hyprctl reload >/dev/null 2>&1
            # Signal Kitty to reload config
            pkill -USR1 kitty 2>/dev/null
            # Restart Waybar
            systemctl --user restart waybar.service 2>/dev/null || pkill -SIGUSR2 waybar 2>/dev/null
            ;;
          wallpaper)
            # Get current wallpaper filename
            local current_wp=$(hyprctl hyprpaper listactive 2>/dev/null | grep "=" | awk '{print $NF}' | head -n1)
            [ -z "$current_wp" ] && current_wp=$(grep "wallpaper =" ~/.config/hypr/hyprpaper.conf | cut -d',' -f2 | xargs)
            local current_name=$(basename "$current_wp")

            # Get all images in the wallpapers folder
            shopt -s nullglob
            local wps=("$wp_path"/*.jpg "$wp_path"/*.jpeg "$wp_path"/*.png "$wp_path"/*.webp)
            shopt -u nullglob
            
            local count=''${#wps[@]}
            if [ "$count" -eq 0 ]; then
              echo "No wallpapers found in $wp_path. Contents:"
              ls -F "$wp_path"
              return 1
            fi

            local next_wp=""
            for i in "''${!wps[@]}"; do
              local name=$(basename "''${wps[$i]}")
              if [ "$name" = "$current_name" ]; then
                local next_idx=$(( (i + 1) % count ))
                next_wp="''${wps[$next_idx]}"
                break
              fi
            done
            
            # Fallback if no match or first run
            if [ -z "$next_wp" ]; then 
              next_wp="''${wps[0]}"
              if [ "$(basename "$next_wp")" = "$current_name" ] && [ "$count" -gt 1 ]; then
                 next_wp="''${wps[1]}"
              fi
            fi
            
            echo "Found $count images. Current: $current_name -> Switching to: $(basename "$next_wp")"
            hyprctl hyprpaper preload "$next_wp"
            hyprctl hyprpaper wallpaper ",$next_wp"
            ;;
          *)
            echo "Usage: theme-switch [palette|wallpaper]"
            ;;
        esac
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
}
