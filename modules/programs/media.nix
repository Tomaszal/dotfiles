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
}
