{ lib, ... }:

{
  # TODO: change defaults from performance/balanced -> balanced/power-saver
  services.tlp = {
    enable = true;
    # enable power management for nvidia gpu per https://wiki.archlinux.org/title/TLP#PRIME_with_NVIDIA_driver
    # maybe also set RUNTIME_PM_ON_AC=auto for power management on ac too? (see https://linrunner.de/tlp/support/optimizing.html#opt-reduce-power-on-ac)
    # i think there are three profiles to use in tlp, maybe default to balanced profile on ac (where the default is performance) and have a script to change to performance when necessary (then don't need to use cpupower or whatever to change governor as well)
    settings.RUNTIME_PM_ENABLE = "01:00.0";
  };

  specialisation.mobile.configuration = {
    system.nixos.tags = [ "mobile" ];

    boot.blacklistedKernelModules = [
      "nvidia"
      "nouveau"
    ];

    services.xserver.videoDrivers = lib.mkForce [ ];

    hardware.nvidia = {
      modesetting.enable = lib.mkForce false;

      powerManagement = {
        enable = lib.mkForce false;
        finegrained = lib.mkForce false;
      };

      prime.offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
    };
  };
}
