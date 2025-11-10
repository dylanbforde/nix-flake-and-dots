# /home/dylan/nixos-config/modules/home-manager.nix
{
  home-manager.users.dylan = {
    imports = [ ./home.nix ];
  };
}
