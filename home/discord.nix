{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dawson.discord;
in
{
  options.dawson.discord.nixcord = lib.mkOption {
    description = ''
      If enabled, install and configure Discord with Nixcord; otherwise, use the package in Nixpkgs
    '';
    type = lib.types.bool;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nixcord {
      programs.nixcord = {
        enable = true;
        config = {
          themeLinks = with config.catppuccin; [
            "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
          ];
        };

        discord.autoscroll.enable = true;
      };
    })

    (lib.mkIf (!cfg.nixcord) {
      home.packages = [
        (pkgs.discord.override {
          withVencord = true;
          enableAutoscroll = true;
        })
      ];
    })
  ];
}
