{ config, pkgs, lib, ... }:

{
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

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
    name = lib.mkDefault "Bibata-Modern-Classic";
    package = lib.mkDefault pkgs.bibata-cursors;
    size = lib.mkDefault 24;
    gtk.enable = lib.mkDefault true;
    x11.enable = lib.mkDefault true;
  };

  # Programs customized via Home Manager
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      if command -v eza >/dev/null 2>&1; then
       alias ls='eza --icons=auto --group-directories-first'
       alias ll='eza -la --icons=auto --group-directories-first'
      fi

      # Distrobox Helpers
      db-cuda() {
      local name="cuda-$(basename "$PWD")"
      if ! distrobox list | grep -q "$name"; then
      echo "Creating CUDA container: $name"
      distrobox create -Y -n "$name" --image nvidia/cuda:12.4.1-devel-ubuntu22.04 --nvidia --home "$PWD" --init-hooks "apt-get update && apt-get install -y curl"
      fi
      distrobox enter "$name" -- bash -c 'if ! command -v uv &> /dev/null; then echo "Installing uv..."; curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path; fi; exec bash'
      }

      db-dev() {
      if ! distrobox list | grep -q "devbox"; then
      echo "Starting devbox..."
      distrobox create -n devbox --image ubuntu:22.04 --init-hooks "apt-get update && apt-get install -y curl"
      fi
      distrobox enter devbox -- bash -c 'if ! command -v uv &> /dev/null; then echo "Installing uv..."; curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --no-modify-path; fi; exec bash'
      }

    '';
  };

  # Modern CLI Tools
  programs.zoxide.enable = true;
  programs.fzf = {
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
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.helix = {
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
