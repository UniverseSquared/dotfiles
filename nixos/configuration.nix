{ inputs, pkgs, ... }:

{
  imports = [
    ./acer
    ./graphics.nix
    ./hardware-configuration.nix
  ];

  nix.settings = {
    substituters = [
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
    ];

    trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

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

  networking.hostName = "nixos-laptop";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";

  users.users.dawson = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

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

  environment.systemPackages = with pkgs; [ gnupg pinentry-gtk2 ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  system.stateVersion = "25.05";
}
