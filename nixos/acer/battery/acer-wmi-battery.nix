{
  stdenv,
  kernel,
  pkgs,
  ...
}:

stdenv.mkDerivation rec {
  name = "acer-wmi-battery";

  src = pkgs.fetchFromGitHub {
    owner = "frederik-h";
    repo = name;
    rev = "0889d3ea54655eaa88de552b334911ce7375952f";
    sha256 = "sha256-mI6Ob9BmNfwqT3nndWf3jkz8f7tV10odkTnfApsNo+A=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

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
