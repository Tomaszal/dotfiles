{den, ...}: {
  den.aspects.collaboration = {
    includes = [(den.batteries.unfree ["slack"])];

    homeManager = {mv, ...}: {
      home.packages = [mv.tip.slack];
    };
  };
}
