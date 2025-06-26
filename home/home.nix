{ config, pkgs, ... }:

{
  imports = [
    ./anyrun
    ./discord.nix
    ./dunst.nix
    ./emacs
    ./eza.nix
    ./firefox.nix
    ./git.nix
    # ./hyprland
    ./kitty.nix
    ./niri.nix
    ./nx
    ./rofi.nix
    ./theme.nix
    ./thunderbird.nix
    ./waybar
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    acpi
    feh
    file
    libreoffice
    lutris
    nix-output-monitor
    osu-lazer-bin
    pavucontrol
    prismlauncher
    tree
  ];

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
