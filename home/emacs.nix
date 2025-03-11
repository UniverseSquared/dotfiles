{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30.override {
      withGTK3 = true;
      withPgtk = true;
    };
    extraPackages =
      epkgs: with epkgs; [
        nix-mode
        catppuccin-theme
        llama
      ];
    # extraConfig = builtins.readFile ./init.el;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
