{ pkgs, ... }:

{
  projectRootFile = "flake.nix";
  settings.on-unmatched = "debug";

  programs.nixfmt.enable = true;
  programs.rustfmt.enable = true;
}
