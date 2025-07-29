{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  templateToRuby = name: info: ''
    "${name}" => {
      "path" => "${info.path}",
      "description" => "${info.description}",
    },
  '';
in
{
  home.packages = [
    (pkgs.replaceVarsWith {
      src = ./nx.rb;

      replacements = {
        inherit (pkgs) nix-output-monitor nvd ruby;

        templates = ''
          {
            ${lib.concatStrings (lib.mapAttrsToList templateToRuby inputs.self.templates)}
          }
        '';
      };

      name = "nx";
      dir = "bin";
      isExecutable = true;
      meta.mainProgram = "nx";
    })
  ];
}
