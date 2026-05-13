{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    age
    gitleaks
    sops
  ];

  # This repo is public. Do not add plaintext secrets here.
  # Add encrypted sops files only after an age recipient is declared.
  sops = {
    age.keyFile = "/home/dylan/.config/sops/age/keys.txt";
    secrets = { };
  };
}
