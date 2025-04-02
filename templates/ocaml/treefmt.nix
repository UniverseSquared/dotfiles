{ pkgs, ... }:

{
  projectRootFile = "flake.nix";
  settings.on-unmatched = "debug";

  programs.nixfmt.enable = true;
  programs.ocamlformat.enable = true;
}
