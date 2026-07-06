{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPmcyc4NXr9PQFsAs5Iv5SrxLkVmuTfwUTyOXYZzMoq forde.dylan@gmail.com"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
