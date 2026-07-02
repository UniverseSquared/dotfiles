{ lib, ... }:

{
  # TODO: change defaults from performance/balanced -> balanced/power-saver
  services.tlp = {
    enable = true;
    # enable power management for nvidia gpu per https://wiki.archlinux.org/title/TLP#PRIME_with_NVIDIA_driver
    # maybe also set RUNTIME_PM_ON_AC=auto for power management on ac too? (see https://linrunner.de/tlp/support/optimizing.html#opt-reduce-power-on-ac)
    # i think there are three profiles to use in tlp, maybe default to balanced profile on ac (where the default is performance) and have a script to change to performance when necessary (then don't need to use cpupower or whatever to change governor as well)
    settings = {
      TLP_DEFAULT_MODE = "BAL";
      TLP_AUTO_SWITCH = 0;

      RUNTIME_PM_ENABLE_ON_AC = "auto";
      RUNTIME_PM_ENABLE = "01:00.0"; # autosuspend nvidia gpu
    };
  };
}
