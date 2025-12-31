{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    registry.dotfiles.flake = inputs.self;

    settings = {
      max-jobs = 1;
      cores = 10;

      warn-dirty = false;

      trusted-users = [ "dawson" ];

      substituters = [
        "https://anyrun.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.nur.overlays.default
      inputs.niri.overlays.niri
    ];
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      extraEntries."arch.conf" = ''
        title Arch Linux
        efi   /EFI/GRUB/grubx64.efi
      '';
    };

    efi.canTouchEfiVariables = true;
  };

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "kala";

  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
  };

  networking.dhcpcd.enable = true;

  time.timeZone = "Europe/London";

  users.users.dawson = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  dawson.desktop.session = "niri";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # required for gpg pinentry to work
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-gtk2
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # networking = {
  #   dhcpcd.enable = true;
  #   useDHCP = lib.mkForce true;
  # };

  hardware.bluetooth.enable = true;

  systemd.user.services.xdg-document-portal.serviceConfig.TimeoutStopSec = 10;

  services.flatpak.enable = true;
  services.mullvad-vpn.enable = true;
  services.ratbagd.enable = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.jellyfin.wantedBy = lib.mkForce [ ];

  system.stateVersion = "25.05";
}
