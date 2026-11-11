{den, ...}: {
  den.default = {
    includes = [(den.batteries.unfree ["spotify"])];

    homeManager = {
      pkgs,
      mv,
      ...
    }: {
      home.packages =
        (with mv.fast.latest; [pinta vlc])
        ++ [pkgs.spotify];

      programs.obs-studio = {
        enable = true;
        package = mv.fast.latest.obs-studio.eval;
      };
    };
  };
}
