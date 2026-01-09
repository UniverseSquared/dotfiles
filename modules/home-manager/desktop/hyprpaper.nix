{ config, ... }:

let
  wallpaper = "${config.home.homeDirectory}/dotfiles/wallpaper.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [
        {
          monitor = "eDP-1";
          path = wallpaper;
        }
      ];
    };
  };

  systemd.user.services.hyprpaper = {
    Install.WantedBy = [
      "niri.service"
      "hyprland-session.target"
    ];

    Unit.After = [
      "niri.service"
      "hyprland-session.target"
    ];
  };
}
