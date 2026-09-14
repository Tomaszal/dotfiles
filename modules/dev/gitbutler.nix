{
  den.aspects.dev.gitbutler.homeManager = {inputs', ...}: {
    home.packages = with inputs'.llm-agents.packages; [
      but
      gitbutler
    ];
  };
}
