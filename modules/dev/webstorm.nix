{den, ...}: {
  den.aspects.dev.webstorm = {
    includes = [(den.batteries.unfree ["webstorm"])];

    homeManager = {mv, ...}: {
      home.packages = with mv.tip.jetbrains; [webstorm];
    };
  };
}
