{
  den.aspects.dev.homeManager = {pkgs-mv, ...}: {
    programs.gh = {
      enable = true;
      package = pkgs-mv.tip.gh;
      extensions = with pkgs-mv.tip; [gh-stack];
    };
  };
}
