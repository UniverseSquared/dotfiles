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
    pavucontrol
    tree
  ];

  programs.git = {
    enable = true;
    userName = "UniverseSquared";
    userEmail = "universesquared4@gmail.com";

    signing.signByDefault = true;

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

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
