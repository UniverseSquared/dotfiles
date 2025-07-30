{ config, pkgs, ... }:

{
  imports = [ ../../modules/home-manager/syncthing.nix ];

  home.packages = [ pkgs.fastfetchMinimal ];

  programs.home-manager.enable = true;

  dawson.syncthing.folders = {
    cemu = {
      path = "~/Emulation/roms/wiiu/mlc01/usr/save";
      devices = [
        "kala"
        "waso"
        "phone"
      ];
    };
  };

  home = {
    username = "deck";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "24.11";
  };
}
