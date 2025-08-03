{ config, lib, ... }:

let
  cfg = config.dawson.desktop;
in
{
  imports = [
    ./brightness.nix
    ./hyprpaper.nix
    ./power-menu.nix
    ./screenshot.nix
    ./session
  ];

  options.dawson.desktop = {
    session = lib.mkOption {
      type = lib.types.enum [
        "hyprland"
        "niri"
      ];
    };
  };

  config = lib.mkMerge [
    {
      home.file.".XCompose".source = ./XCompose;
    }

    (lib.mkIf (cfg.session == "hyprland") {
      dawson.desktop.hyprland.enable = true;
    })

    (lib.mkIf (cfg.session == "niri") {
      dawson.desktop.niri.enable = true;
    })
  ];
}
