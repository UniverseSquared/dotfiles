{ pkgs, ... }:

{
  home.packages = with pkgs; [
    source-sans
    # for org-mode inline latex preview (i'm not sure why installing `texlivePackages.dvipng` doesn't work?)
    texliveMedium
  ];

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
        consult
        direnv
        edit-indirect
        haskell-mode
        hl-todo
        kdl-mode
        ligature
        llama
        lua-mode
        magit
        marginalia
        markdown-mode
        merlin
        nix-mode
        ocamlformat
        orderless
        org
        org-appear
        org-superstar
        rainbow-delimiters
        rust-mode
        s
        smartparens
        transient # magit wants a newer version than emacs' builtin package
        tuareg
        vertico
        web-mode
        with-editor # required for magit
        yaml-mode
        zig-mode

        sly
        geiser-guile

        # for org html exports
        htmlize

        (treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-elixir
            tree-sitter-heex
            tree-sitter-tsx
            tree-sitter-typescript
          ]
        ))
      ];
    extraConfig = builtins.readFile ./init.el;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
