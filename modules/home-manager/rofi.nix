{ config, pkgs, ... }:

{
  home.packages = [ pkgs.source-sans ];

  programs.rofi = {
    enable = true;
    font = "${config.dawson.fonts.variable.name} 12";

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
