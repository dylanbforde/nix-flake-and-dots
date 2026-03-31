{ lib, pkgs, ... }:

let
  palettes = import ./palettes.nix;
in
{
  options.theme = {
    palette = lib.mkOption {
      type = lib.types.attrs;
      default = palettes.mocha;
      description = "The active color palette.";
    };
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../wallpapers/background_wallpaper.jpg;
      description = "The active wallpaper path.";
    };
    opacity = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Window opacity.";
    };
    glass = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable glassy effects.";
    };
    screensaver = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable screensaver and auto-suspend.";
    };
  };
}
