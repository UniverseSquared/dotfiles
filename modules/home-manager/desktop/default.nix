{
  imports = [
    ./brightness.nix
    ./hyprpaper.nix
    ./power-menu.nix
    ./screenshot.nix
    ./session
  ];

  config = {
    home.file.".XCompose".source = ./XCompose;
  };
}
