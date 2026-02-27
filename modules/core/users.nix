{ config, pkgs, ... }:

{
  users.users.dylan = {
    isNormalUser = true;
    description = "Dylan";
    # 🛡️ Sentinel: Removed "docker" group to prevent privilege escalation.
    # Rootless Docker is enabled in dev.nix, so this group is unnecessary
    # and compromises security isolation.
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
