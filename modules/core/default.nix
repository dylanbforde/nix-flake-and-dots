{ config, pkgs, ... }:

{
  imports = [
    ./system.nix
    ./users.nix
  ];
}
