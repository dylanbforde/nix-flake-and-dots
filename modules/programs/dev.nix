{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    helix
    distrobox
    devenv
    uv

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
    package = pkgs.docker_29;
    rootless = {
      enable = true;
      package = pkgs.docker_29;
      setSocketVariable = true;
    };
  };
}
