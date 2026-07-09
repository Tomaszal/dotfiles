{
  den.default.homeManager = {
    config,
    inputs',
    ...
  }: {
    home.packages = [inputs'.nur.legacyPackages.repos.lonerOrz.helium];

    programs.chromium.enable = true;

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}
