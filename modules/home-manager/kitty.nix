{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka";
      size = 12;
      package = pkgs.iosevka;
    };

    settings = {
      background_opacity = 0.75;
      mouse_hide_wait = 0; # disable mouse hiding
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };

    keybindings = {
      # scroll up/down with (keypad) page up/down
      "ctrl+KP_PAGE_UP" = "scroll_page_up";
      "ctrl+KP_PAGE_DOWN" = "scroll_page_down";
    };
  };
}
