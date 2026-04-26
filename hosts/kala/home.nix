{ config, osConfig, pkgs, ... }:

{
  imports = [ ./syncthing.nix ];

  home.packages = with pkgs; [
    acpi
    fairfax-hd
    feh
    file
    godot
    jetbrains.idea
    jetbrains.rider
    libreoffice
    # FIXME: temporary workaround for lutris build failure
    ((import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "2d293cbfa5a793b4c50d17c05ef9e385b90edf6c";
      sha256 = "sha256-pp3uT4hHijIC8JUK5MEqeAWmParJrgBVzHLNfJDZxg4=";
    }) { inherit (pkgs.stdenv.hostPlatform) system; config.allowUnfree = true; }).lutris)
    nix-output-monitor
    noto-fonts
    osu-lazer-bin
    pavucontrol
    prismlauncher
    qbittorrent
    tree
    unityhub
    unzip

    (vintagestory.override { waylandSupport = true; })
  ];

  dawson.discord.nixcord = true;

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/dotfiles";
  };

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.htop.enable = true;
  programs.mangohud.enable = true;
  programs.ripgrep.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;

    nix-direnv = {
      enable = true;
      package = osConfig.nix.package;
    };

    config.global.log_filter = "^(un)?loading";
  };

  home.stateVersion = "24.11";
}
