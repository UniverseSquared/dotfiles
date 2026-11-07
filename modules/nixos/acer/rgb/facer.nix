# https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module/issues/136#issuecomment-1889949470
{
  kernel,
  kernelModuleMakeFlags,
  pkgs,
  stdenv,
  ...
}:

stdenv.mkDerivation rec {
  name = "facer";

  src = pkgs.fetchFromGitHub {
    owner = "JafarAkhondali";
    repo = "acer-predator-turbo-and-rgb-keyboard-linux-module";
    rev = "343c715669ef52ccecdb65473e7318f612b6b6c2";
    sha256 = "sha256-RKqe3kHZ32Pv+6skP4x+sB+c4dlyES0Bu2C73LvkgqQ=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "O=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];
}
