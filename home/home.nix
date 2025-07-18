{ config, pkgs, ... }:

{
  imports = [
    ./anyrun
    ./desktop
    ./discord.nix
    ./dunst.nix
    ./emacs
    ./eza.nix
    ./firefox.nix
    ./git.nix
    ./kitty.nix
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
    unzip
    # jetbrains.rider # https://github.com/NixOS/nixpkgs/issues/425328
    noto-fonts
    godot
  ];

  dawson = {
    desktop.session = "hyprland";
    discord.nixcord = false; # https://github.com/KaylorBen/nixcord/pull/121
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
