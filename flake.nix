{
  description = "Dawson's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    anyrun.url = "github:anyrun-org/anyrun";

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

      nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              sharedModules = [
                inputs.catppuccin.homeModules.catppuccin
                inputs.nixcord.homeModules.nixcord
              ];

              users.dawson = import ./home/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      templates = {
        c = {
          path = ./templates/c;
          description = "C template with make";
        };

        ocaml = {
          path = ./templates/ocaml;
          description = "OCaml template with Dune";
        };

        rust = {
          path = ./templates/rust;
          description = "Rust template with stable rustc/cargo via rust-overlay";
        };
      };
    };
}
