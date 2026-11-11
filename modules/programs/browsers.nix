{
  den.default.homeManager = {
    config,
    inputs',
    mv,
    ...
  }: {
    home.packages = [inputs'.nur.legacyPackages.repos.lonerOrz.helium];

    programs.chromium = {
      enable = true;
      package = mv.fast.latest.chromium.eval;
    };

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}
