{den, ...}: {
  den.aspects.dev.obsidian = {
    includes = [(den.batteries.unfree ["obsidian"])];

    homeManager = {pkgs, ...}: {
      programs.obsidian = {
        enable = true;
        package = pkgs.obsidian;
      };
    };
  };
}
