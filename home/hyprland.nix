{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # explicitly set to null to use the system packages
    package = null;
    portalPackage = null;

    settings = {
      monitor = "eDP-1, 1920x1080@165, 0x0, 1, vrr, 1";
      bind = [
        "SUPER, Return, exec, kitty"
        "SUPER, W, killactive"
        "SUPER, F, fullscreen"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
