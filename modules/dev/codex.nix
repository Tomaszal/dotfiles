{den, ...}: {
  den.aspects.dev.codex = {
    includes = [den.aspects.dev.codexbar];

    homeManager = {pkgs-unstable, ...}: {
      programs.codex = {
        enable = true;
        package = with pkgs-unstable; codex;
      };

      codexbar.providers.codex.source = "cli";
    };
  };
}
