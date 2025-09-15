{
  networking.nameservers = [ "1.1.1.1" ];

  # don't allow networkmanager to modify resolv.conf -- otherwise it adds nameservers found through dhcp
  networking.networkmanager.dns = "none";
}
