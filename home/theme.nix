{ pkgs, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  home.pointerCursor = {
    gtk.enable = true;

    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
    };

    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefers-dark";
  };
}
