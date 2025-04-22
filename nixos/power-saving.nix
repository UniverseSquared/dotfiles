{ lib, ... }:

{
  services.tlp.enable = true;

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
