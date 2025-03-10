{ pkgs, ... }:

{
  imports = [ ./hyprland.nix ];

  home.packages = with pkgs; [
    emacs
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
