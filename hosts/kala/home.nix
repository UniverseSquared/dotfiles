{ config, pkgs, ... }:

{
  imports = [ ./syncthing.nix ];

  home.packages = with pkgs; [
    acpi
    feh
    file
    godot
    jetbrains.rider
    libreoffice
    lutris
    nix-output-monitor
    noto-fonts
    osu-lazer-bin
    pavucontrol
    prismlauncher
    tree
    unzip
  ];

  dawson = {
    desktop.session = "hyprland";
    discord.nixcord = true;
  };

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
