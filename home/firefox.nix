{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          betterttv
          bitwarden
          darkreader
          firefox-color
          stylus
          ublock-origin
        ];
      };

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
        "sidebar.revamp" = false; # ensure that the sidebar is disabled
        "middlemouse.paste" = false;
        "browser.startup.page" = 3; # restore previous tabs on startup
        "browser.urlbar.trimURLs" = false; # always show the entire url

        # disable picture in picture popup option on videos
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

        # remove search bar and stuff from new tab page
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };
    };
  };
}
