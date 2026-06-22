{ osConfig, inputs, ... }:

{
  programs.spicetify = {
    enable = true;
    theme = inputs.spicetify-nix.legacyPackages.x86_64-linux.themes.catppuccin;
    colorScheme = osConfig.dawson.theme.flavor;
    enabledExtensions = [
      inputs.spicetify-nix.legacyPackages.x86_64-linux.extensions.adblockify
    ];

    spotifyLaunchFlags = "--enable-blink-features=MiddleClickAutoscroll";
  };
}
