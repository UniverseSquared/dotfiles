{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.gamescope ];

    extraCompatPackages = [
      (pkgs.callPackage ./proton-ge.nix { })
    ];
  };
}
