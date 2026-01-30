{ config, pkgs, ... }:

{
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.stateVersion = "25.05";

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

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
}
