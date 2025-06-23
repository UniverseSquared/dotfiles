{ config, pkgs, ... }:

let
  facer-rgb = pkgs.callPackage ./facer-rgb.nix { };
in
{
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./rgb.nix { })
    (config.boot.kernelPackages.callPackage ./acer-wmi-battery.nix { })
  ];

  boot.kernelModules = [
    "facer"
    "acer_wmi_battery"
  ];

  boot.blacklistedKernelModules = [ "acer_wmi" ];

  environment.systemPackages = [ facer-rgb ];

  # turn off rgb at startup
  systemd.user.services.acer-rgb = {
    enable = true;
    script = ''
      ${facer-rgb}/bin/facer-rgb -b 0
    '';

    wantedBy = [ "default.target" ];
  };
}
