{
  den.aspects.dev.agents.homeManager = {sources, ...}: {
    programs.agent-skills = {
      sources.asyraf = {
        path = sources.asyraf-agent-skills.src;
        subdir = "skills";
      };
      skills.enable = ["testing-best-practices"];
    };
  };
}
