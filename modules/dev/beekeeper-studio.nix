{
  den.aspects.dev.homeManager = {mv, ...}: {
    home.packages = with mv.fast.latest; [beekeeper-studio];
  };
}
