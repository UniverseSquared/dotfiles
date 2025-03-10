{ pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs
    git
    gnupg
    nh
    kitty
  ];

  programs.bash.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    # explicitly set to null to use the system packages
    package = null;
    portalPackage = null;

    settings = {
      monitor = "eDP-1, 1920x1080@165, 0x0, 1, vrr, 1";
      bind = [ "SUPER, Return, exec, kitty" ];
    };
  };

  home.stateVersion = "24.11";
}
