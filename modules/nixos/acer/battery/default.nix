{ config, ... }:

{
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./acer-wmi-battery.nix { })
  ];

  boot.kernelModules = [ "acer_wmi_battery" ];
  boot.blacklistedKernelModules = [ "acer_wmi" ];

  boot.extraModprobeConfig = ''
    options acer_wmi_battery enable_health_mode=1
  '';
}
