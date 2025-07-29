{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings.capture = "kms";

    applications.apps =
      let
        setResolution = pkgs.writeShellScript "set-resolution" ''
          hyprctl keyword monitor "eDP-1, $1@165, 0x0, 1, vrr, 0"
        '';

        launchSteamBigPicture = pkgs.writeShellScript "steam-big-picture" ''
          while pgrep steam >/dev/null; do pkill steam; done

          hyprctl dispatch exec '${pkgs.gamescope}/bin/gamescope \
            --backend sdl --steam --fullscreen -w 1280 -h 800 -- steam -tenfoot'
        '';
      in
      [
        {
          name = "Steam Big Picture";
          detached = [ "${launchSteamBigPicture}" ];
          prep-cmd = [
            {
              do = "${setResolution} 1280x800";
              undo = "${setResolution} 1920x1080";
            }
          ];
        }
      ];
  };
}
