{den, ...}: {
  den.aspects.social = {
    includes = [(den.batteries.unfree ["discord" "discord-unwrapped"])];

    homeManager = {pkgs-mv, ...}: {
      programs.discord = {
        enable = true;
        package = with pkgs-mv.tip; discord;
      };

      home.packages = with pkgs-mv.tip; [
        signal-desktop
        telegram-desktop
      ];
    };
  };
}
