{ pkgs, ... }:

{
  imports = [
    ./emacs.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    git
    gnupg
    nh
    kitty
    pavucontrol
  ];

  programs.bash.enable = true;
  programs.firefox.enable = true;

  home.stateVersion = "24.11";
}
