{ config, pkgs, ... }:

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
    lutris
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
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.11";
}
