{ pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs
    git
    gnupg
    nh
  ];

  programs.bash.enable = true;

  home.stateVersion = "24.11";
}
