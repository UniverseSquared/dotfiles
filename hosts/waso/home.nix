{ config, pkgs, ... }:

{
  imports = [ ../../modules/home-manager/syncthing.nix ];

  home.packages = [ pkgs.fastfetchMinimal ];

  programs.home-manager.enable = true;

  dawson.syncthing.folders = {
    cemu.path = "~/Emulation/roms/wiiu/mlc01/usr/save";
  };

  home.file.".ssh/authorized_keys".text = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQpyYLWtwsOePRYFPucbVoqkTEOB7D22MWYvTGvGBmG dawson@kala
  '';

  home = {
    username = "deck";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "24.11";
  };
}
