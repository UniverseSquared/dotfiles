{ pkgs, ... }:

{
  imports = [
    ./discord.nix
    ./emacs.nix
    ./hyprland.nix
  ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  home.packages = with pkgs; [
    git
    gnupg
    nh
    pavucontrol
  ];

  programs.bash.enable = true;
  programs.firefox.enable = true;
  programs.kitty.enable = true;

  home.stateVersion = "24.11";
}
