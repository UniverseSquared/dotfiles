{
  programs.git = {
    enable = true;
    userName = "UniverseSquared";
    userEmail = "universesquared4@gmail.com";

    signing.signByDefault = true;

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";

      # don't use a pager for `git stash list`
      pager.stash = false;
    };
  };
}
