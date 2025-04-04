{
  programs.thunderbird = {
    enable = true;
    profiles.dawson = {
      isDefault = true;
      settings = {
        "mailnews.default_view_flags" = 0; # unthreaded view
        # only sync messages from within the last 30 days (instead of everything)
        "mail.server.server2.autosync_max_age_days" = 30;
        "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";
        "mail.uidensity" = 0; # increase ui density
      };
    };
  };
}
