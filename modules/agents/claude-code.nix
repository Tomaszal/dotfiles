{den, ...}: {
  den.aspects.dev.agents.claude-code = {
    includes = [(den.batteries.unfree ["claude-code"])];

    homeManager = {pkgs-mv, ...}: {
      programs.claude-code = {
        enable = true;
        package = with pkgs-mv.tip; claude-code;
        context = ./instructions.md;
      };

      programs.agent-skills.targets.claude.enable = true;

      codexbar.providers.claude.source = "cli";
    };
  };
}
