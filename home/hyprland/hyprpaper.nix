{ config, ... }:

let
  wallpaper = "${config.home.homeDirectory}/dotfiles/wallpaper.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ "eDP-1,${wallpaper}" ];
    };
  };
}
