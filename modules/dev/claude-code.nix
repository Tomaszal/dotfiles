{den, ...}: {
  den.aspects.dev.claude-code = {
    includes = [
      (den.batteries.unfree ["claude-code"])
      den.aspects.dev.codexbar
    ];

    homeManager = {pkgs-unstable, ...}: {
      programs.claude-code = {
        enable = true;
        package = with pkgs-unstable; claude-code;
      };

      codexbar.providers.claude.source = "cli";
    };
  };
}
