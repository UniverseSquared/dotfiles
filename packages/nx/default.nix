{
  guile,
  guile-json,
  lib,
  makeWrapper,
  nvd,
  stdenv,
  ...
}:

stdenv.mkDerivation {
  name = "nx";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ guile ];

  makeFlags = [ "ROOT=${placeholder "out"}" ];

  env = {
    GUILE_LOAD_PATH = lib.makeSearchPath "share/guile/site/3.0" [
      (placeholder "out")
      guile-json
    ];

    GUILE_LOAD_COMPILED_PATH = lib.makeSearchPath "lib/guile/3.0/site-ccache" [
      (placeholder "out")
      guile-json
    ];
  };

  postInstall = ''
    wrapProgram $out/bin/nx \
      --prefix PATH : ${lib.makeBinPath [ nvd ]} \
      --prefix GUILE_LOAD_PATH : ${guile-json}/share/guile/site/3.0:$out/share/guile/site/3.0 \
      --prefix GUILE_LOAD_COMPILED_PATH : \
        ${guile-json}/lib/guile/3.0/site-ccache:$out/lib/guile/3.0/site-ccache \
      --set GUILE_AUTO_COMPILE 0
  '';
}
