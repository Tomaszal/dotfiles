{
  den.aspects.dev.agents.homeManager = {sources, ...}: {
    programs.agent-skills = {
      sources.adhd = {
        path = sources.i-have-adhd.src;
        subdir = "skills";
      };
      skills.enable = ["i-have-adhd"];
    };
  };
}
