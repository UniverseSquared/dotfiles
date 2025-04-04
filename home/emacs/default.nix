{ pkgs, ... }:

{
  home.packages = [ pkgs.source-sans ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30.override {
      withGTK3 = true;
      withPgtk = true;
    };
    extraPackages =
      epkgs: with epkgs; [
        catppuccin-theme
        company
        counsel
        direnv
        edit-indirect
        haskell-mode
        hl-todo
        ivy
        ligature
        llama
        lua-mode
        magit
        markdown-mode
        merlin
        nix-mode
        ocamlformat
        org
        org-appear
        org-superstar
        rainbow-delimiters
        rust-mode
        s
        smartparens
        swiper
        transient # magit wants a newer version than emacs' builtin package
        tuareg
        web-mode
        with-editor # required for magit
        yaml-mode
        zig-mode
      ];
    extraConfig = builtins.readFile ./init.el;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
