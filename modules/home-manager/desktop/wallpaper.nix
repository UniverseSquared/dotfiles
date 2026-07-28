{ config, lib, pkgs, ... }:

let
  wallpaper = "${config.home.homeDirectory}/dotfiles/wallpaper.png";
in
{
  services.awww = {
    enable = true;
    extraArgs = [ "--no-cache" ];
  };

  systemd.user.services.awww-set-wallpaper = {
    Install.WantedBy = [ "awww.service" ];
    Unit.After = [ "awww.service" ];

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "awww-set-wallpaper" ''
        # hacky way to wait for awww to properly start; otherwise `awww img` is called before the socket
        # is created
        while [ ! -S $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY-awww-daemon.sock ]; do
          sleep 0.1
        done

        ${lib.getExe config.services.awww.package} img -t none ${wallpaper}
      '';
    };
  };
}
