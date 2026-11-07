{
  kernel,
  kernelModuleMakeFlags,
  pkgs,
  stdenv,
  ...
}:

stdenv.mkDerivation rec {
  name = "acer-wmi-battery";

  src = pkgs.fetchFromGitHub {
    owner = "frederik-h";
    repo = name;
    rev = "9f90d75cc9237aeed7964622d10dbdf4d2c7b518";
    sha256 = "sha256-mI6Ob9BmNfwqT3nndWf3jkz8f7tV10odkTnfApsNo+A=";
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
