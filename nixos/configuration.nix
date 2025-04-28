{ lib, inputs, pkgs, ... }:

{
  imports = [
    ./acer
    ./graphics.nix
    ./hardware-configuration.nix
    ./keyd.nix
    ./power-saving.nix
  ];

  nix = {
    registry.dotfiles.flake = inputs.self;

    settings = {
      max-jobs = 1;
      cores = 10;

      substituters = [
        "https://anyrun.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = [ inputs.nur.overlays.default ];
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

  networking.hostName = "nixos-laptop";

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

  programs.steam = {
    enable = true;
    extraPackages = [ pkgs.gamescope ];
  };

  documentation.dev.enable = true;

  networking = {
    dhcpcd.enable = true;
    useDHCP = lib.mkForce true;
  };

  system.stateVersion = "25.05";
}
