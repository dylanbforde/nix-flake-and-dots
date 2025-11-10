# /home/dylan/nixos-config/hosts/nixos-laptop/configuration.nix
{
  imports = [
    ./hardware-configuration.nix
  ];

  ################################
  # Bootloader
  ################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ################################
  # Host / Network
  ################################
  networking.hostName = "nixos-laptop";

  ################################
  # State version
  ################################
  system.stateVersion = "25.05";

  networking.networkmanager.enable = true;

  # Enable PipeWire for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };
  
}
