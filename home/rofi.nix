{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        window = {
          border-radius = mkLiteral "12px";
        };
      };
  };
}
