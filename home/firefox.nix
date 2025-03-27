{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.dawson = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        ublock-origin
      ];

      search = {
        force = true;
        default = "ddg";
      };

      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.aboutConfig.showWarning" = false;
        "general.autoScroll" = true; # enable middle click scrolling
        "ui.key.menuAccessKeyFocuses" = false; # don't summon the menu bar with alt
      };
    };
  };
}
