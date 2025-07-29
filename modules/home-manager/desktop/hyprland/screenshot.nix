{ pkgs, lib, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot" ''
    outPath="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H:%M:%S.png)"
    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$outPath"
    ${pkgs.wl-clipboard}/bin/wl-copy < "$outPath"
  '';

  viewLastScreenshot = pkgs.writeShellScript "viewLastScreenshot" ''
    ${lib.getExe pkgs.feh} $(ls --sort=name ~/Pictures/Screenshots/* | tail -n1)
  '';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER SHIFT, s, exec, ${screenshot}"
    "SUPER CONTROL, s, exec, ${viewLastScreenshot}"
  ];
}
