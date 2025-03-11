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
    };
  };
}
