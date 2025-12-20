{
  config,
  osConfig,
  pkgs,
  ...
}:

let
  powerMenu = pkgs.writeShellScript "power-menu" ''
    case $(echo -e "Shutdown\nReboot\nSleep\nLogout" | rofi -dmenu -i) in
      Shutdown) shutdown now;;
      Reboot) reboot;;
      Sleep) systemctl suspend;;
      Logout)
        ${
          if osConfig.dawson.desktop.session == "hyprland" then
            "hyprctl dispatch exit"
          else
            "niri msg action quit"
        }
        ;;
    esac
  '';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER SHIFT, q, exec, ${powerMenu}"
  ];

  programs.niri.settings.binds."Mod+Shift+Q".action = config.lib.niri.actions.spawn "${powerMenu}";
}
