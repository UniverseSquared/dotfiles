{ pkgs, lib, ... }:

let
  powerMenu = pkgs.writeShellScript "power-menu" ''
    case $(echo -e "Shutdown\nReboot\nSleep\nLogout" | rofi -dmenu -i) in
      Shutdown) shutdown now;;
      Reboot) reboot;;
      Sleep) systemctl suspend;;
      Logout) hyprctl dispatch exit;;
    esac
  '';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER SHIFT, q, exec, ${powerMenu}"
  ];
}
