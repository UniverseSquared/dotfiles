{ pkgs ? import <nixpkgs> {} }:

let
  inherit (pkgs) callPackage guile-json mkShell rlwrap;
in
mkShell {
  inputsFrom = [ (callPackage ./default.nix { }) ];

  packages = [ rlwrap ];

  GUILE_AUTO_COMPILE = 0;

  GUILE_LOAD_PATH = "${guile-json}/share/guile/site/3.0";
  GUILE_LOAD_COMPILED_PATH = "${guile-json}/lib/guile/3.0/site-ccache";

  shellHook = ''
    export GUILE_LOAD_PATH=$GUILE_LOAD_PATH:$(pwd)
  '';
}
