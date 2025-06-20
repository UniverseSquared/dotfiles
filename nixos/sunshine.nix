{ lib, ... }:

{
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # don't start sunshine on boot
  systemd.user.services.sunshine.wantedBy = lib.mkForce [ ];
}
