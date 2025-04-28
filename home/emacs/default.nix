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

        (treesit-grammars.with-grammars (g: with g; [ tree-sitter-elixir tree-sitter-heex ]))
      ];
    extraConfig = builtins.readFile ./init.el;
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
