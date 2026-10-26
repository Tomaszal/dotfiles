{den, ...}: {
  den.aspects.collaboration = {
    includes = [(den.batteries.unfree ["slack"])];

    homeManager = {pkgs-mv, ...}: {
      home.packages = [pkgs-mv.tip.slack];
    };
  };
}
