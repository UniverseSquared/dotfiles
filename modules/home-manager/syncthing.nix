{ config, lib, ... }:

let
  cfg = config.dawson.syncthing;

  devices = {
    kala = "WQYSFEU-HCT6KE6-5QJBGUN-DRDL4KQ-PTSQZIW-G4DPACZ-YA5D7L7-RVFVQQJ";
    waso = "AQRCJUI-WCTVBXM-JR2ETBF-BHUAL4U-YPHSJHK-ZHSXJOH-LHIZZC6-4GNBLAB";
    phone = "26PP6Z3-TB6WGN4-SZPKQYC-S37STFY-PPIP7EI-VTG5LH2-BYJGX4S-ZXC4WAA";
  };
in
{
  options.dawson.syncthing = {
    folders = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              description = ''
                The path of the folder to be shared (prefixed with either `/` or `~/`).
              '';
              type = lib.types.str;
            };

            devices = lib.mkOption {
              description = ''
                The hostname of each device this folder is to be shared with.
              '';
              type = lib.types.listOf (lib.types.enum (lib.attrNames devices));
            };
          };
        }
      );
    };
  };

  config = {
    services.syncthing = {
      enable = true;
      settings = {
        devices = lib.mapAttrs (name: id: { inherit name id; }) devices;

        folders = cfg.folders;

        options.urAccepted = -1;
      };
    };
  };
}
