{inputs, ...}: {
  flake-file.inputs = {
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    i-have-adhd = {
      url = "github:ayghri/i-have-adhd";
      flake = false;
    };
  };

  den.aspects.dev.agents.homeManager = {
    imports = [inputs.agent-skills.homeManagerModules.default];

    programs.agent-skills = {
      enable = true;
      sources.adhd = {
        path = inputs.i-have-adhd;
        subdir = "skills";
      };
      skills.enable = ["i-have-adhd"];
      excludePatterns = [];
    };
  };
}
