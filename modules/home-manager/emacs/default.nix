{ config, osConfig, pkgs, ... }:

{
  home.packages = with pkgs; [
    source-sans
    # for org-mode inline latex preview (i'm not sure why installing `texlivePackages.dvipng` doesn't work?)
    (texliveMedium.withPackages (p: [ p.tikz-cd ]))
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs31.override {
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
        fish-mode
        glsl-mode
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

        just-mode

        elm-mode

        gdscript-mode

        (treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-elixir
            tree-sitter-heex
            tree-sitter-kdl
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

  systemd.user.services.switch-emacs-theme = {
    Install.WantedBy = [ "default.target" ];

    Unit = {
      After = [ "emacs.service" ];
      X-RestartIfChanged = true;
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${config.services.emacs.package}/bin/emacsclient --eval \
          '(my/set-theme-variant ${if osConfig.dawson.theme.variant == "light" then "t" else "nil"})'
      '';
    };
  };
}
