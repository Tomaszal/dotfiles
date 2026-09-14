{den, ...}: {
  den.aspects.dev.claude-code = {
    includes = [
      (den.batteries.unfree ["claude-code"])
      den.aspects.dev.codexbar
    ];

    homeManager = {pkgs-mv, ...}: {
      programs.claude-code = {
        enable = true;
        package = with pkgs-mv.tip; claude-code;
      };

      codexbar.providers.claude.source = "cli";
    };
  };
}
