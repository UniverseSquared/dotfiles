{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "Source Sans 3 12";

    extraConfig.show-icons = true;

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
