{ pkgs, ... }:

let
  nixpkgs-manual-desktop = pkgs.makeDesktopItem {
    name = "nixpkgs-manual";
    desktopName = "Nixpkgs Manual";
    exec = "firefox ${pkgs.nixpkgs-manual}/share/doc/nixpkgs/index.html";
    icon = "nix-snowflake";
  };
in
{
  documentation = {
    dev.enable = true;
    man.generateCaches = true; # required for e.g. `consult-man` to work in emacs
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    nixpkgs-manual-desktop
  ];
}
