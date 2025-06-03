{ pkgs, ... }:

let
  brightness = pkgs.writeShellScript "brightness" ''
    device="/sys/class/backlight/nvidia_wmi_ec_backlight"
    max_brightness=$(< $device/max_brightness)
    current_brightness=$(< $device/brightness)

    step=50

    case $1 in
      down) new_brightness=$(($current_brightness - $step));;
      up)   new_brightness=$(($current_brightness + $step));;
    esac

    new_brightness=$(($new_brightness < 10 ? 10 : $new_brightness))
    new_brightness=$(($new_brightness > 255 ? 255 : $new_brightness))

    echo $new_brightness | sudo tee $device/brightness
  '';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, F9, exec, ${brightness} down"
    "SUPER, F10, exec, ${brightness} up"
  ];
}
