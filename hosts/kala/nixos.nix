{
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
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  networking.networkmanager.enable = true;
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

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # required for gpg pinentry to work
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-gtk2
    man-pages
    man-pages-posix
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  documentation.dev.enable = true;

  # networking = {
  #   dhcpcd.enable = true;
  #   useDHCP = lib.mkForce true;
  # };

  hardware.bluetooth.enable = true;

  systemd.user.services.xdg-document-portal.serviceConfig.TimeoutStopSec = 10;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = { };
  };

  services.flatpak.enable = true;
  services.mullvad-vpn.enable = true;

  system.stateVersion = "25.05";
}
