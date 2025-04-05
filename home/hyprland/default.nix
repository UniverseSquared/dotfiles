{ config, lib, ... }:

let
  mainMod = "SUPER";

  cursorTheme = "Adwaita";
  cursorSize = 24;
in
{
  imports = [
    ./hyprpaper.nix
    ./power-menu.nix
  ];

  home.sessionVariables = {
    HYPRCURSOR_THEME = cursorTheme;
    HYPRCURSOR_SIZE = cursorSize;

    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = cursorSize;
  };

  # start hyprland on login
  programs.bash.profileExtra = ''
    [ -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1 ] && exec Hyprland
  '';

  home.file.".XCompose".source = ./XCompose;

  wayland.windowManager.hyprland = {
    enable = true;

    # explicitly set to null to use the system packages
    package = null;
    portalPackage = null;

    settings = {
      monitor = "eDP-1, 1920x1080@165, 0x0, 1, vrr, 2";

      exec-once = [ "hyprctl setcursor ${cursorTheme} ${toString cursorSize}" ];

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

      input.kb_options = "caps:escape, compose:ralt";

      misc.force_default_wallpaper = 0;

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
          size = 5;
          passes = 2;
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
          "${mainMod}, S, togglefloating"
          "${mainMod}, Space, exec, anyrun"
          "${mainMod}, B, exec, firefox"
          "${mainMod}, E, exec, emacsclient -nc"

          "${mainMod}, up, movefocus, u"
          "${mainMod}, down, movefocus, d"
          "${mainMod}, left, movefocus, l"
          "${mainMod}, right, movefocus, r"

          "${mainMod} SHIFT, up, movewindow, u"
          "${mainMod} SHIFT, down, movewindow, d"
          "${mainMod} SHIFT, left, movewindow, l"
          "${mainMod} SHIFT, right, movewindow, r"

          # workaround for discord global mute keybind; set 'toggle mute' bind in discord with:
          #  sleep 2; hyprctl dispatch "sendkeystate , XF86Launch9, down, class:^(discord)$"
          "CTRL SHIFT, semicolon, sendshortcut, , XF86Launch9, class:^(discord)$"
        ]
        ++ eachWs (ws: "${mainMod}, ${toString (lib.mod ws 10)}, workspace, ${toString ws}")
        ++ eachWs (
          ws: "${mainMod} SHIFT, ${toString (lib.mod ws 10)}, movetoworkspacesilent, ${toString ws}"
        );

      # window resizing ('e' bind flag repeats the command when the keys are held)
      binde = [
        "${mainMod} CONTROL, up, resizeactive, 0 -10"
        "${mainMod} CONTROL, down, resizeactive, 0 10"
        "${mainMod} CONTROL, left, resizeactive, -10 0"
        "${mainMod} CONTROL, right, resizeactive, 10 0"

        "${mainMod} CONTROL SHIFT, up, resizeactive, 0 10"
        "${mainMod} CONTROL SHIFT, down, resizeactive, 0 -10"
        "${mainMod} CONTROL SHIFT, left, resizeactive, 10 0"
        "${mainMod} CONTROL SHIFT, right, resizeactive, -10 0"
      ];

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];
    };
  };
}
