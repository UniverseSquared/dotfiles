{ config, pkgs, ... }:

let
  facer-rgb = pkgs.callPackage ./facer-rgb.nix { };
in
{
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rgb.nix { })
  ];

  boot.kernelModules = [ "facer" ];

  environment.systemPackages = [ facer-rgb ];

  # turn off rgb at startup
  systemd.services.acer-rgb = {
    enable = true;
    script = ''
      ${facer-rgb}/bin/facer-rgb -b 0
    '';

    wantedBy = [ "multi-user.target" ];
  };
}
