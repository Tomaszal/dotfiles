{
  den.default.homeManager = {config, ...}: {
    programs.chromium.enable = true;

    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
  };
}
