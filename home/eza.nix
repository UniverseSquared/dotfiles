{
  programs.eza.enable = true;

  # also use eza as a replacement for tree
  home.shellAliases = {
    tree = "eza --long --tree";
  };
}
