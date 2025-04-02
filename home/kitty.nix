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
    };
  };
}
