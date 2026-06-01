{ inputs, ... }:

{
  # place a link to the flake source in the system toplevel
  system.systemBuilderCommands = ''
    ln -s ${inputs.self} $out/flake
  '';
}
