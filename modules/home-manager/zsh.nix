{
  catppuccin.zsh-syntax-highlighting.enable = false;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "fishy";
    };
  };
}
