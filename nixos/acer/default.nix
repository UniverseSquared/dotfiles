{ config, ... }:

{
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rgb.nix { })
  ];

  boot.kernelModules = [ "facer" ];
}
