{
  catppuccin.fish.enable = false;

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
  };
}
