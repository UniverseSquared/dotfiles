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
    rev = "343c715669ef52ccecdb65473e7318f612b6b6c2";
    sha256 = "sha256-RKqe3kHZ32Pv+6skP4x+sB+c4dlyES0Bu2C73LvkgqQ=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # makeFlags = kernel.makeFlags ++ [
  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "O=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];
}
