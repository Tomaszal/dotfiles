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

        settings = {
          approvals_reviewer = "auto_review";
          # https://github.com/openai/codex/issues/33952
          features.mcp_2026_07_28 = true;
          suppress_unstable_features_warning = true;
        };

        # Network access permits remote writes without crossing the sandbox.
        # Keep pushes subject to review; local edits rely on sandbox boundaries.
        rules.sensitive-operations = ''
          prefix_rule(
            pattern = ["git", "push"],
            decision = "prompt",
            justification = "Review changes to a remote repository.",
          )
        '';
      };

      programs.agent-skills.targets.agents.enable = true;

      codexbar.providers.codex.source = "cli";
    };
  };
}
