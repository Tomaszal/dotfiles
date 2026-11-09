{inputs, ...}: {
  flake-file.inputs = {
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.dev.agents.homeManager = {lib, ...}: {
    imports = [inputs.agent-skills.homeManagerModules.default];

    # Home Manager also links Claude's MCP plugin under skills/.
    # Synchronize first so all declared Home Manager files are restored afterward.
    home.activation.agent-skills = lib.hm.dag.entryBefore ["linkGeneration"] (lib.mkDefault "");

    programs.agent-skills = {
      enable = true;
      excludePatterns = [
        "/unmanaged/"
        "/unmanaged-*/"
      ];
    };
  };
}
