{
  den.aspects.games.minecraft.homeManager = {mv, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = mv.fast.latest.prismlauncher;
    };
  };
}
