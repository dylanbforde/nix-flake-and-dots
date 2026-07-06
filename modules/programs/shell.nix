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
        bashrcExtra = builtins.readFile ./bashrc.sh;
      };
    };
  };
}
