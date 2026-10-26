{
  den.aspects.dev.agents.opencode.homeManager = {pkgs-mv, ...}: {
    programs.opencode = {
      enable = true;
      context = ./instructions.md;
      enableMcpIntegration = true;
      package = with pkgs-mv.tip; opencode;
    };

    programs.agent-skills.targets.opencode.enable = true;
  };
}
