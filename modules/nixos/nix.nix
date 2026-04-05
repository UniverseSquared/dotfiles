{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.latest)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    registry.dotfiles.flake = inputs.self;

    settings = {
      max-jobs = 1;
      cores = 10;

      warn-dirty = false;

      trusted-users = [ "dawson" ];

      substituters = [
        "https://anyrun.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
