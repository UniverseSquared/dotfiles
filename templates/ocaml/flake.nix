{
  description = "OCaml template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

      packages.x86_64-linux.default = pkgs.ocamlPackages.buildDunePackage {
        pname = "%%project-name%%";
        version = "0.1.0";
        duneVersion = "3";
        src = ./.;

        buildInputs = with pkgs.ocamlPackages; [ ];
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        inputsFrom = [ self.packages.x86_64-linux.default ];
      };
    };
}
