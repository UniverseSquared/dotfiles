{ pkgs, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";

    kvantum.enable = false;

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
    theme.name = "Adwaita-dark";

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefers-dark";
  };

  home.sessionVariables.GTK_THEME = "Adwaita:dark";

  qt = {
    enable = true;
    style = {
      package = pkgs.kdePackages.breeze;
      name = "breeze";
    };
  };
}
