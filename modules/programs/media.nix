{den, ...}: {
  den.default = {
    includes = [(den.batteries.unfree ["spotify"])];

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        pinta
        spotify
        vlc
      ];

      programs.obs-studio.enable = true;
    };
  };

  den.aspects.media.flameshot = {screen}: {
    homeManager = {pkgs-unstable, ...}: {
      services.flameshot = {
        enable = true;
        package = with pkgs-unstable; flameshot;
      };

      custom-keybindings.flameshot = {
        command = "flameshot screen --edit --number ${toString screen}";
        binding = "Print";
      };

      # Disable default screenshot util
      dconf.settings."org/gnome/shell/keybindings".show-screenshot-ui = [];
    };
  };
}
