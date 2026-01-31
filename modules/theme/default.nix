{ lib, ... }:

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
      description = "The active wallpaper path.";
    };
  };
}
