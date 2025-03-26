{ config, pkgs, ... }:

{
  imports = [
    ./anyrun
    ./discord.nix
    ./emacs
    ./hyprland.nix
    ./kitty.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  home.packages = with pkgs; [
    git
    gnupg
    pavucontrol
    tree
  ];

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/dotfiles";
  };

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.firefox.enable = true;
  programs.htop.enable = true;

  home.stateVersion = "24.11";
}
