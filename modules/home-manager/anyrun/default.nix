{ inputs, pkgs, ... }:

{
  programs.anyrun = {
    enable = true;
    config = {
      x.fraction = 0.5;
      y.fraction = 0.5;
      width.absolute = 600;
      height.absolute = 595;
      showResultsImmediately = true;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        rink
        symbols
      ];
    };

    extraCss = builtins.readFile ./style.css;
  };
}
