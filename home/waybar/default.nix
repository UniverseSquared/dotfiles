{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.settings.exec-once = [ "waybar" ];

  home.packages = [ pkgs.font-awesome ];

  catppuccin.waybar.mode = "createLink";

  xdg.configFile."waybar/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/waybar/style.css";

  programs.waybar = {
    enable = true;
    settings = {
      bar = {
        position = "top";
        height = 20;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "wireplumber"
          "cpu"
          "memory"
          "disk"
          "battery"
        ];

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";

          persistent-workspaces."*" = 3;
        };

        "hyprland/window" = {
          format = "{title:.100}";
          icon = true;
          icon-size = 22;
        };

        clock = {
          format = " {:%a %Y-%m-%d %I:%M:%S %p}";
          interval = 1;
        };

        wireplumber.format = " {volume}%";

        cpu = {
          format = " {usage}%";
          interval = 5;
        };

        memory = {
          format = " {used}GiB";
          interval = 5;
        };

        disk.format = " {free} free on /";

        battery = {
          states = {
            veryLow = 15;
            low = 35;
            mid = 50;
            high = 65;
            limit = 80;
            full = 100;
          };

          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
      };
    };
  };
}
