{ config, pkgs, ... }:

{
  imports = [
    ./anyrun
    ./discord.nix
    ./emacs
    ./firefox.nix
    ./hyprland
    ./kitty.nix
    ./rofi.nix
    ./theme.nix
    # TODO: modularise config (i.e. so that things can be configured/disabled more easily)
    # FIXME: temporarily not using thunderbird home manager module because of this bug:
    # https://github.com/nix-community/home-manager/issues/6800
    # ./thunderbird.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    acpi
    feh
    file
    pavucontrol
    prismlauncher
    tree
    thunderbird # FIXME: ditto above
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
  programs.htop.enable = true;
  programs.ripgrep.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "24.11";
}
