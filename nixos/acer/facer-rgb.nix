{ stdenv, pkgs, ... }:

stdenv.mkDerivation {
  name = "facer-rgb";

  src = pkgs.fetchFromGitHub {
    owner = "JafarAkhondali";
    repo = "acer-predator-turbo-and-rgb-keyboard-linux-module";
    rev = "5d4a850b67b5923e3eb5acb514de0a40dc800d84";
    sha256 = "sha256-8Wa01nB3Peor0GkstetPf8pljY6chYp+GyoA/pqbpuM=";
  };

  buildInputs = [ pkgs.python3 ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 ./facer_rgb.py $out/bin/facer-rgb
  '';
}
