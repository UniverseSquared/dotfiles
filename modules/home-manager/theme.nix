{
  config,
  osConfig,
  pkgs,
  ...
}:

let
  isDarkTheme = osConfig.dawson.theme.variant == "dark";
in
{
  catppuccin = {
    enable = true;
    autoEnable = true;

    flavor = osConfig.dawson.theme.flavor;
    accent = osConfig.dawson.theme.accent;

    # workaround for a build error with the catppuccin flake
    mako.enable = false;
  };

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;

    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-${if isDarkTheme then "dark" else "light"}";
    gtk4.theme = config.gtk.theme;

    gtk3.extraConfig.gtk-application-prefer-dark-theme = isDarkTheme;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = isDarkTheme;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = if isDarkTheme then "prefers-dark" else "prefers-light";
  };

  home.sessionVariables.GTK_THEME = "Adwaita:${if isDarkTheme then "dark" else "light"}";

  # required for catppuccin qt theme
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
}
