{ config, lib, ... }:

{
  programs.zsh.profileExtra = ''
    [ -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1 ] && exec niri-session
  '';

  programs.niri = {
    settings = {
      prefer-no-csd = true; # disable client-side decorations

      spawn-at-startup = [
        { command = [ "waybar" ]; }
      ];

      layout.border = {
        width = 2;
        active = "#c6a0f6";
      };

      input = {
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
      };

      binds =
        with config.lib.niri.actions;
        {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return".action = spawn "kitty";
          "Mod+Space".action = spawn "rofi" "-show" "drun";

          "Mod+Up".action = focus-window-up;
          "Mod+Down".action = focus-window-down;
          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;

          "Mod+WheelScrollUp".action = focus-column-right;
          "Mod+WheelScrollDown".action = focus-column-left;

          "Mod+Ctrl+Up".action = move-window-up;
          "Mod+Ctrl+Down".action = move-window-down;
          "Mod+Ctrl+Left".action = move-column-left;
          "Mod+Ctrl+Right".action = move-column-right;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";

          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+F".action = expand-column-to-available-width;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          "Mod+Shift+Q".action = quit;
        }
        // lib.listToAttrs (
          lib.genList (ws: {
            name = "Mod+${toString (ws + 1)}";
            value.action = focus-workspace (ws + 1);
          }) 9
        );
    };
  };
}
