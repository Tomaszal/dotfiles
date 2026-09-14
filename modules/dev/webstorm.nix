{den, ...}: {
  den.aspects.dev.webstorm = {
    includes = [(den.batteries.unfree ["webstorm"])];

    homeManager = {pkgs-mv, ...}: {
      home.packages = with pkgs-mv.tip.jetbrains; [webstorm];
    };
  };
}
