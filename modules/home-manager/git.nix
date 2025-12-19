{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "UniverseSquared";
        email = "universesquared4@gmail.com";
      };

      init.defaultBranch = "main";
      credential.helper = "store";

      # don't use a pager for `git stash list`
      pager.stash = false;
    };

    signing.signByDefault = true;
  };
}
