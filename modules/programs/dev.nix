{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    helix
    distrobox
    gemini-cli
    devenv
    
    # Languages / Tools (Persistent env)
    # Add more here as needed to avoid ephemeral shells
    google-cloud-sdk
    cargo
    rustc
    python3
    nodejs
    gcc
  ];
  
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    rootless.enable = true;
  };
}
