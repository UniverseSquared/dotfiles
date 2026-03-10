{ config, ... }:

{
  catppuccin.zsh-syntax-highlighting.enable = false;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "fishy";
    };
  };
}
