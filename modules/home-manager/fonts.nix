{ config, lib, pkgs, ... }:

{
  options.dawson.fonts = {
    fixed = {
      name = lib.mkOption {
        description = "The name of the fixed pitch (monospace) font to use by default";
        type = lib.types.str;
      };

      package = lib.mkOption {
        description = "The package providing the fixed pitch font";
        type = lib.types.package;
      };
    };

    variable = {
      name = lib.mkOption {
        description = "The name of the fixed pitch (monospace) font to use by default";
        type = lib.types.str;
      };

      package = lib.mkOption {
        description = "The package providing the fixed pitch font";
        type = lib.types.package;
      };
    };
  };

  config = {
    dawson.fonts = {
      fixed = rec {
        name = "Iosevka Dawson";
        package = (pkgs.iosevka.override {
          privateBuildPlan = {
            family = name;
            spacing = "normal";
            serifs = "sans";
            noCvSs = true;
            exportGlyphNames = true;

            ligations = {
              inherits = "haskell";
              enables = [
                "exeq"           # !=
                "exeqeq"         # !==
                "exeqeqeq"       # !===
                "brst"           # (* and *)
                "slash-asterisk" # /* and */
              ];
            };

            variants.design = {
              lig-equal-chain = "without-notch";
              lig-ltgteq = "slanted";
            };
          };
        }).overrideAttrs (finalAttrs: {
          preBuild = (finalAttrs.preBuild or "") + ''
            export NIX_BUILD_CORES=6
          '';
        });
      };

      variable = {
        name = "Source Sans 3";
        package = pkgs.source-sans;
      };
    };

    home.packages = [
      config.dawson.fonts.fixed.package
      config.dawson.fonts.variable.package
    ];
  };
}
