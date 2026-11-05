{
  den.aspects.dev.agents.homeManager = {sources, ...}: {
    programs.agent-skills = {
      sources.ponytail = {
        path = sources.ponytail.src;
        subdir = "skills";
      };
      skills.enableAll = ["ponytail"];
    };
  };
}
