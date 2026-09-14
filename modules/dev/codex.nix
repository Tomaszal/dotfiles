{den, ...}: {
  den.aspects.dev.codex = {
    includes = [den.aspects.dev.codexbar];

    homeManager = {pkgs-mv, ...}: {
      programs.codex = {
        enable = true;
        package = with pkgs-mv.tip; codex;
      };

      codexbar.providers.codex.source = "cli";
    };
  };
}
