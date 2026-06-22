{ lib, osConfig, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "10x10";
        font = "Iosevka 12";
        corner_radius = 6;
        frame_width = 2;
      };
    };
  };

  # catppuccin/nix places its configuration in dunstrc.d which takes precedence over user settings, so put
  # theme overrides in dunstrc.d as well
  xdg.configFile."dunst/dunstrc.d/99-dawson.conf".text =
    let
      toDunstIni = lib.generators.toINI {
        mkKeyValue =
          key: value:
          let
            value' = if lib.isString value then ''"${value}"'' else toString value;
          in
          "${key}=${value'}";
      };

      background = osConfig.dawson.theme.palette.base + "bf";
    in
    toDunstIni {
      # frame_color = osConfig.dawson.theme.palette.base + "bf";
      global = {
        frame_color = osConfig.dawson.theme.palette.accent;
      };

      urgency_low = { inherit background; };
      urgency_normal = { inherit background; };
      urgency_critical = { inherit background; };
    };
}
