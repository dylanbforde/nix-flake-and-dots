{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    atuin
    carapace
    comma
    nix-index
    nh
    nix-output-monitor
    nvd
  ];

  home-manager.users.dylan = _: {
    programs = {
      atuin = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          auto_sync = false;
          update_check = false;
        };
      };

      nix-index = {
        enable = true;
        enableBashIntegration = true;
      };

      bash = {
        enable = true;
        shellAliases = {
          ls = "eza --icons=auto --group-directories-first";
          ll = "eza -la --icons=auto --group-directories-first";
          gs = "git status --short --branch";
          lg = "git log --oneline --decorate --graph -20";
          nr = "nh os build ~/nixos-config";
          ns = "printf '%s\n' \"sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)\"";
          nfu = "nix flake update --flake ~/nixos-config";
          ndiff = "nvd diff /run/current-system result";
          secret-scan = "gitleaks detect --redact --source .";
        };
        bashrcExtra = ''
          if command -v carapace >/dev/null 2>&1; then
            export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
            source <(carapace _carapace bash)
          fi

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
    };
  };
}
