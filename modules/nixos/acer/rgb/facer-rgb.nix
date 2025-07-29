{ stdenv, pkgs, ... }:

stdenv.mkDerivation {
  name = "facer-rgb";

  src = pkgs.fetchFromGitHub {
    owner = "JafarAkhondali";
    repo = "acer-predator-turbo-and-rgb-keyboard-linux-module";
    rev = "343c715669ef52ccecdb65473e7318f612b6b6c2";
    sha256 = "sha256-RKqe3kHZ32Pv+6skP4x+sB+c4dlyES0Bu2C73LvkgqQ=";
  };

  buildInputs = [ pkgs.python3 ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 ./facer_rgb.py $out/bin/facer-rgb
  '';
}
