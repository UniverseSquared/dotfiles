{
  virtualisation.libvirtd.enable = true;

  users.users.dawson.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;

  # required for virt-manager
  security.polkit.enable = true;
}
