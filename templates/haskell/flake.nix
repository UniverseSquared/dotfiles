{
  description = "Haskell template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      {
        packages.x86_64-linux.default = pkgs.haskellPackages.developPackage {
          root = ./.;
        };

        devShells.x86_64-linux.default = pkgs.mkShell {
          inputsFrom = [ self.packages.x86_64-linux.default ];

          nativeBuildInputs = [ pkgs.cabal-install ];
        };
      };
}
