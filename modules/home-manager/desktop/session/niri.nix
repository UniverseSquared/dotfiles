{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf (osConfig.dawson.desktop.session == "niri") {
  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];

      configPackages = [ osConfig.programs.niri.package ];
    };
  };

  programs.niri = {
    settings = {
      environment.DISPLAY = ":0";

      prefer-no-csd = true; # disable client-side decorations

      spawn-at-startup = [
        { command = [ "${lib.getExe pkgs.xwayland-satellite}" ]; }
      ];

      hotkey-overlay.skip-at-startup = true;

      gestures.hot-corners.enable = false;

      layout = {
        focus-ring.enable = false;

        gaps = 5;

        struts = {
          top = 10;
          bottom = 10;
          left = 10;
          right = 10;
        };

        border = {
          enable = true;
          width = 2;
          active.color = "#c6a0f6";
        };

        shadow.enable = true;

        background-color = "transparent";

        insert-hint = {
          enable = true;
          display.color = "#c6a0f67f";
        };
      };

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 6.;
            top-right = 6.;
            bottom-left = 6.;
            bottom-right = 6.;
          };

          clip-to-geometry = true;
        }

        {
          matches = [
            { app-id = "discord"; }
          ];

          default-column-width.proportion = 1.0;
        }
      ];

      layer-rules = [
        {
          matches = [
            { namespace = "^hyprpaper$"; }
          ];

          place-within-backdrop = true;
        }
      ];

      overview.workspace-shadow.enable = false;

      input.focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };

      binds =
        with config.lib.niri.actions;
        {
          "Mod+Return".action = spawn "kitty";
          "Mod+Space".action = spawn "rofi" "-show" "drun";
          "Mod+E".action = spawn "emacsclient" "-nc";
          "Mod+B".action = spawn "firefox";

          "Mod+Up".action = focus-window-up;
          "Mod+Down".action = focus-window-down;
          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;

          "Mod+WheelScrollUp".action = focus-column-left;
          "Mod+WheelScrollDown".action = focus-column-right;

          "Mod+Shift+WheelScrollUp".action = focus-workspace-up;
          "Mod+Shift+WheelScrollDown".action = focus-workspace-down;

          "Mod+Shift+Up".action = move-window-up;
          "Mod+Shift+Down".action = move-window-down;
          "Mod+Shift+Left".action = move-column-left;
          "Mod+Shift+Right".action = move-column-right;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";

          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+F".action = fullscreen-window;
          "Mod+S".action = toggle-window-floating;

          # i don't know if the mod+ctrl+shift+f binding is a smart way to do this, maybe use mod+shift+r
          # for switch-preset-window-height instead
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+F".action = set-column-width "100%";
          "Mod+Ctrl+F".action = expand-column-to-available-width;
          "Mod+Ctrl+Shift+F".action = set-window-height "100%";

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+W".action = close-window;

          "Mod+Grave".action = toggle-overview;
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
            value.action.move-window-to-workspace = [
              { focus = false; }
              (ws + 1)
            ];
          }) 9
        );
    };
  };
}
