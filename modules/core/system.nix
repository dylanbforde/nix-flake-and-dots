{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Security: explicitly define polkit state for secure graphical privilege escalation
  security.polkit.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  zramSwap.enable = true;

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    blueman.enable = true;
    printing.enable = true;
    upower.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };

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
  # Sound & Bluetooth & Printing
  ################################
  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    font-awesome
  ];
}
