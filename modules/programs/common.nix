{ config, inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unstable.antigravity
    inputs.codex-cli-nix.packages.${pkgs.system}.default
    brave
    git
    xfce.thunar
    xfce.thunar-archive-plugin
    btop
    spotify
    fzf
    zoxide
    eza
    ripgrep
    fd
    discord
    vlc
    pavucontrol
    imv
    zathura
    yazi
    unzip
    jq
    playerctl
    obsidian
    rclone
    tmux
  ];

  # Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar.enable = true;

  # Gaming
  programs.steam.enable = true;

  # CLI Tools config
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
