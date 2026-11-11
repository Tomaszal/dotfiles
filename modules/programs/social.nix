{den, ...}: {
  den.aspects.social = {
    includes = [(den.batteries.unfree ["discord" "discord-unwrapped"])];

    homeManager = {mv, ...}: {
      programs.discord = {
        enable = true;
        package = with mv.tip; discord;
      };

      home.packages = with mv.fast.latest; [
        signal-desktop
        telegram-desktop
      ];
    };
  };
}
