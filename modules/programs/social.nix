{den, ...}: {
  den.aspects.social = {
    includes = [(den.batteries.unfree ["discord" "discord-unwrapped"])];

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
}
