{ config, lib, ... }:

let
  mainMod = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    # explicitly set to null to use the system packages
    package = null;
    portalPackage = null;

    settings = {
      monitor = "eDP-1, 1920x1080@165, 0x0, 1";

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        "col.active_border" = "\$${config.catppuccin.accent}";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      # don't warp the cursor (e.g. when changing window focus)
      cursor.no_warps = true;

      input.kb_options = "caps:escape";

      decoration = {
        rounding = 10;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      dwindle = {
        force_split = 2; # always split to the right/bottom
        preserve_split = true;
      };

      bind =
        let
          eachWs = f: builtins.genList (ws: f (ws + 1)) 10;
        in
        [
          "${mainMod}, Return, exec, kitty"
          "${mainMod}, W, killactive"
          "${mainMod}, F, fullscreen"
          "${mainMod}, Space, exec, anyrun"
          "${mainMod}, B, exec, firefox"
          "${mainMod}, E, exec, emacsclient -nc"

          "${mainMod}, up, movefocus, u"
          "${mainMod}, down, movefocus, d"
          "${mainMod}, left, movefocus, l"
          "${mainMod}, right, movefocus, r"
        ]
        ++ eachWs (ws: "${mainMod}, ${toString (lib.mod ws 10)}, workspace, ${toString ws}")
        ++ eachWs (
          ws: "${mainMod} SHIFT, ${toString (lib.mod ws 10)}, movetoworkspacesilent, ${toString ws}"
        );

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];
    };
  };
}
