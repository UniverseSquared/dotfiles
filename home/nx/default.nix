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

  scriptPrelude = ''
    #!${lib.getExe pkgs.ruby}

    $templates = {
      ${lib.concatStrings (lib.mapAttrsToList templateToRuby inputs.self.templates)}
    }
  '';
in
{
  home.packages = [
    (pkgs.writeScriptBin "nx" (scriptPrelude + builtins.readFile ./nx.rb))
  ];
}
