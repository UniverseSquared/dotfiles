{ config, ... }:

{
  programs.nixcord = {
    enable = true;
    config = {
      themeLinks = with config.catppuccin; [
        "https://catppuccin.github.io/discord/dist/catppuccin-${flavor}-${accent}.theme.css"
      ];
    };
  };
}
