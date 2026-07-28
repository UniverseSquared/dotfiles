{
  imports = [
    ./brightness.nix
    ./wallpaper.nix
    ./power-menu.nix
    ./screenshot.nix
    ./session
  ];

  home.file.".XCompose".source = ./XCompose;
}
