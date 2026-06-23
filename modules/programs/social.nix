{den, ...}: {
  den.aspects.social = {
    personal = {
      includes = [(den.batteries.unfree ["discord"])];

      homeManager = {pkgs-unstable, ...}: {
        programs.discord = {
          enable = true;
          package = with pkgs-unstable; discord;
        };

        home.packages = with pkgs-unstable; [
          signal-desktop
          telegram-desktop
        ];
      };
    };

    work = {
      includes = [(den.batteries.unfree ["slack"])];

      homeManager = {pkgs-unstable, ...}: {
        home.packages = with pkgs-unstable; [
          slack
        ];
      };
    };
  };
}
