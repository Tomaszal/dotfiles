{den, ...}: {
  den.aspects.dev.claude-code = {
    includes = [(den.batteries.unfree ["claude-code"])];

    homeManager = {pkgs-unstable, ...}: {
      programs.claude-code = {
        enable = true;
        package = with pkgs-unstable; claude-code;
      };
    };
  };
}
