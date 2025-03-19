{ config, pkgs, ... }:

{
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rgb.nix { })
  ];

  boot.kernelModules = [ "facer" ];

  environment.systemPackages = [
    (pkgs.callPackage ./facer-rgb.nix { })
  ];
}
