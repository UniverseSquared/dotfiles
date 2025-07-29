{
  pkgs,
  stdenv,
  fetchzip,
  ...
}:

let
  protonVersion = "9-27";
in
stdenv.mkDerivation {
  pname = "ge-proton${protonVersion}-bin";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${protonVersion}/GE-Proton${protonVersion}.tar.gz";
    hash = "sha256-70au1dx9co3X+X7xkBCDGf1BxEouuw3zN+7eDyT7i5c=";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  dontBuild = true;

  installPhase = ''
    echo "only use the steamcompattool output" > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool
  '';
}
