{ config, pkgs, ... }:

{
  home.packages = [ pkgs.fastfetchMinimal ];

  programs.home-manager.enable = true;

  home = {
    username = "deck";
    homeDirectory = "/home/${config.home.username}";

    stateVersion = "24.11";
  };
}
