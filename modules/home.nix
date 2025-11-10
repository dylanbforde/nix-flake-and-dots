{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    fzf
    zoxide
    eza
    ripgrep
    fd
    spotify
    btop
    docker
    kitty
    brave
    waybar
    wofi
    hyprpaper
    networkmanagerapplet
    git
    helix
    brightnessctl
    pulseaudio
    cursor.packages.x86_64-linux.cursor
     ];

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
      
      '';
  };

  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  xdg.configFile."waybar/config".source = ./waybar-config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar-style.css;
  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  xdg.configFile."hypr/hyperApps.conf".source = ./hyperApps.conf;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dylan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Enable gnome-keyring service
  services.gnome-keyring.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
