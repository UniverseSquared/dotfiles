# https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module/issues/136#issuecomment-1889949470
{
  stdenv,
  kernel,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  name = "acer-predator-turbo-and-rgb-keyboard-linux-module";

  src = pkgs.fetchFromGitHub {
    owner = "JafarAkhondali";
    repo = name;
    rev = "5d4a850b67b5923e3eb5acb514de0a40dc800d84";
    sha256 = "sha256-8Wa01nB3Peor0GkstetPf8pljY6chYp+GyoA/pqbpuM=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];
}
