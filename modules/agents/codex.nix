{
  den.aspects.dev.agents.codex.homeManager = {pkgs-mv, ...}: {
    programs.codex = {
      enable = true;
      package = with pkgs-mv.tip; codex;
      context = ./instructions.md;
    };

    programs.agent-skills.targets.agents.enable = true;

    codexbar.providers.codex.source = "cli";
  };
}
