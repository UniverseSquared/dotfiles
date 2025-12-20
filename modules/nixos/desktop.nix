{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.dawson.desktop = {
    session = lib.mkOption {
      type = lib.types.enum [
        "hyprland"
        "niri"
      ];
    };
  };

  config =
    let
      sessionCmd =
        if config.dawson.desktop.session == "hyprland" then
          lib.getExe config.programs.hyprland.package
        else
          "${config.programs.niri.package}/bin/niri-session";
    in
    {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      services.greetd = {
        enable = true;
        settings.default_session.command = "${config.services.greetd.package}/bin/agreety --cmd ${sessionCmd}";
      };

      programs.hyprland = {
        enable = config.dawson.desktop.session == "hyprland";
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      programs.niri = {
        enable = config.dawson.desktop.session == "niri";
        package = pkgs.niri-unstable;
      };
    };
}
