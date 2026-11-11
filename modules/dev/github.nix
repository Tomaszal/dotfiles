{
  den.aspects.dev.homeManager = {mv, ...}: {
    programs.gh = {
      enable = true;
      package = mv.fast.latest.gh.eval;
      extensions = with mv.fast.latest; [gh-stack];
    };
  };
}
