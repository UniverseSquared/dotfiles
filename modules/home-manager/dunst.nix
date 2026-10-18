{ config, lib, osConfig, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "10x10";
        font = "${config.dawson.fonts.fixed.name} 12";
        corner_radius = 6;
        frame_width = 2;
      };
    };
  };

  systemd.user.services.dunst.Unit.X-Reload-Triggers = [
    config.catppuccin.flavor
    config.catppuccin.accent
  ];

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
      global.frame_color = osConfig.dawson.theme.palette.accent;

      urgency_low = { inherit background; };
      urgency_normal = { inherit background; };
      urgency_critical = { inherit background; };
    };
}
