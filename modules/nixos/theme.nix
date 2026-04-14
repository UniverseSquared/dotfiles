{
  config,
  lib,
  pkgs,
  ...
}:

let
  palette = lib.importJSON (
    pkgs.fetchurl {
      url = "https://github.com/catppuccin/palette/raw/refs/heads/main/palette.json";
      hash = "sha256-S8EUu2s8mpyeFWVkqoRiWu8yxdpRTZ3UMc8fytQzoF8=";
    }
  );

  themeName = if config.dawson.theme.variant == "light" then "latte" else "macchiato";
  colorNames = lib.attrNames palette.${themeName}.colors;
in
{
  options.dawson.theme = {
    variant = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "dark";
    };

    flavor = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
    };

    accent = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
    };

    palette = lib.mkOption {
      readOnly = true;
      type = lib.types.submodule {
        options =
          lib.genAttrs colorNames (
            color:
            lib.mkOption {
              readOnly = true;
              type = lib.types.str;
            }
          )
          // {
            accent = lib.mkOption {
              readOnly = true;
              type = lib.types.str;
            };
          };
      };
    };
  };

  config = {
    dawson.theme = {
      flavor = if config.dawson.theme.variant == "light" then "latte" else "macchiato";
      accent = if config.dawson.theme.variant == "light" then "pink" else "mauve";

      palette = lib.genAttrs colorNames (color: palette.${themeName}.colors.${color}.hex) // {
        accent = palette.${themeName}.colors.${config.dawson.theme.accent}.hex;
      };
    };

    specialisation.light.configuration = {
      system.nixos.tags = [ "light" ];
      dawson.theme.variant = "light";
    };
  };
}
