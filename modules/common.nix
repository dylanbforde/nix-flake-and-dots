# /home/dylan/nixos-config/modules/common.nix
{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ################################
  # Locale / Time
  ################################
  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  ################################
  # Graphics / Display manager
  ################################
  services.displayManager.ly.enable = true;

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ################################
  # Sound
  ################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ################################
  # Printing (CUPS)
  ################################
  services.printing.enable = true;

  ################################
  # Users
  ################################
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.gnome.gnome-keyring.enable = true;

  ################################
  # Hyprland
  ################################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  ################################
  # Environment / Packages
  ################################
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    rootless.enable = true;
  };

  environment.systemPackages = with pkgs; [
    helix
    kitty
    brave
    waybar
    wofi
    hyprpaper
    networkmanagerapplet
    home-manager
    git
    xfce.thunar
    xfce.thunar-archive-plugin
    btop
    spotify
    tailscale
    wl-clipboard
    fzf
    zoxide
    eza
    ripgrep
    fd
    gemini-cli
    devenv
  ];

  services.tailscale.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    font-awesome
  ];
}
