{ config, pkgs, ... }:

{
  imports = [ ../../modules/home-manager/syncthing.nix ];

  home.packages = [ pkgs.fastfetchMinimal ];

  programs.home-manager.enable = true;

  dawson.syncthing.folders = {
    cemu.path = "~/Emulation/roms/wiiu/mlc01/usr/save";
    yuzu-system.path = "~/Emulation/saves/yuzu/saves/0000000000000000/00000000000000000000000000000000";
    yuzu-user.path = "~/Emulation/saves/yuzu/saves/0000000000000000/86A4E00DFA79AF1B8B771A3785914A25";
    dolphin-wii.path = "~/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/Wii/title/00010000";
    dolphin-gc.path = "~/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/GC";
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
