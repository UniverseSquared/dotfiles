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
        "browser.toolbars.bookmarks.visibility" = "never";

        # restore previous tabs on startup
        "browser.startup.page" = 3;

        # remove search bar and stuff from new tab page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
      };
    };
  };
}
