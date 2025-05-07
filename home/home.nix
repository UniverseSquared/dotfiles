{ config, pkgs, ... }:

{
  imports = [
    ./anyrun
    ./discord.nix
    ./emacs
    ./firefox.nix
    ./git.nix
    ./hyprland
    ./kitty.nix
    ./rofi.nix
    ./theme.nix
    ./thunderbird.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    acpi
    feh
    file
    libreoffice
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
  programs.ripgrep.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.11";
}
