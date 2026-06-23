{den, ...}: {
  den.aspects.games.steam = {
    includes = [(den.batteries.unfree ["steam" "steam-unwrapped"])];

    nixos.programs.steam.enable = true;
  };
}
