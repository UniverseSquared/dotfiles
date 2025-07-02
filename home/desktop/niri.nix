{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.dawson.desktop.niri = {
    enable = lib.mkEnableOption "niri";
  };

  config = lib.mkIf config.dawson.desktop.niri.enable {
    programs.zsh.profileExtra = ''
      [ -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1 ] && exec niri-session
    '';

    programs.niri = {
      settings = {
        environment.DISPLAY = ":0";

        prefer-no-csd = true; # disable client-side decorations

        spawn-at-startup = [
          { command = [ "waybar" ]; }
          { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
        ];

        layout = {
          focus-ring.enable = false;

          border = {
            enable = true;
            width = 2;
            active.color = "#c6a0f6";
          };

          shadow.enable = true;
        };

        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 10.;
              top-right = 10.;
              bottom-left = 10.;
              bottom-right = 10.;
            };

            clip-to-geometry = true;
          }
        ];

        input.focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };

        binds =
          with config.lib.niri.actions;
          {
            "Mod+Shift+Slash".action = show-hotkey-overlay;
            "Mod+Return".action = spawn "kitty";
            "Mod+E".action = spawn "emacsclient" "-nc";
            "Mod+Space".action = spawn "rofi" "-show" "drun";

            "Mod+Up".action = focus-window-up;
            "Mod+Down".action = focus-window-down;
            "Mod+Left".action = focus-column-left;
            "Mod+Right".action = focus-column-right;

            "Mod+WheelScrollUp".action = focus-column-left;
            "Mod+WheelScrollDown".action = focus-column-right;

            "Mod+Shift+Up".action = move-window-up;
            "Mod+Shift+Down".action = move-window-down;
            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Right".action = move-column-right;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            "Mod+R".action = switch-preset-column-width;
            "Mod+Ctrl+F".action = set-column-width "100%";
            "Mod+Shift+F".action = expand-column-to-available-width;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+W".action = close-window;
            "Mod+Shift+Q".action = quit;
          }
          // lib.listToAttrs (
            lib.genList (ws: {
              name = "Mod+${toString (ws + 1)}";
              value.action = focus-workspace (ws + 1);
            }) 9
          )
          // lib.listToAttrs (
            lib.genList (ws: {
              name = "Mod+Shift+${toString (ws + 1)}";
              value.action.move-window-to-workspace = ws + 1;
            }) 9
          );
      };
    };
  };
}
