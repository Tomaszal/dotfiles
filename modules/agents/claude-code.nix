{
  den,
  inputs,
  ...
}: {
  den.aspects.dev.agents.claude-code = {
    includes = [(den.batteries.unfree ["claude-code"])];

    homeManager = {pkgs-mv, ...}: {
      # TODO(NixOS 26.11): Use the release module; remove these overrides,
      # and the inputs argument.
      disabledModules = ["programs/claude-code.nix"];
      imports = ["${inputs.home-manager-unstable}/modules/programs/claude-code"];

      programs.claude-code = {
        enable = true;
        mutableSettings = true;
        enableMcpIntegration = true;
        package = with pkgs-mv.tip; claude-code;
        context = ./instructions.md;
        settings = {
          disableClaudeAiConnectors = true;
          syncClaudeAiPlugins = false;
          syncClaudeAiSkills = false;
          permissions.allow = ["Read(//nix/store/**)"];
        };
      };

      programs.agent-skills.targets.claude.enable = true;

      codexbar.providers.claude.source = "cli";
    };
  };
}
