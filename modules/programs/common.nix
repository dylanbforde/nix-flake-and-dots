{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-antigravity
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
    discord
    vlc
  ];

  # Thunar
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar.enable = true;

  # CLI Tools config
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
