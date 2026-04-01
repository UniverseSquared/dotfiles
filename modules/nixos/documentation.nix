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
    man.cache = {
      enable = true; # required for e.g. `consult-man` to work in emacs
      generateAtRuntime = true;
    };
  };

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    nixpkgs-manual-desktop
  ];
}
