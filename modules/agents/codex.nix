{inputs, ...}: {
  den.aspects.dev.agents.codex = {
    homeManager = {pkgs-mv, ...}: {
      # TODO(NixOS 26.11): Use the release module; remove these overrides,
      # and the inputs argument.
      disabledModules = ["programs/codex.nix"];
      imports = ["${inputs.home-manager-unstable}/modules/programs/codex"];

      programs.codex = {
        enable = true;
        mutableSettings = true;
        enableMcpIntegration = true;
        package = with pkgs-mv.tip; codex;
        context = ./instructions.md;
      };

      programs.agent-skills.targets.agents.enable = true;

      codexbar.providers.codex.source = "cli";
    };
  };
}
