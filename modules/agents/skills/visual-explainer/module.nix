{
  perSystem = {
    pkgs,
    sources,
    ...
  }: {
    packages.visual-explainer = pkgs.callPackage ./_package.nix {
      inherit (sources.visual-explainer) src version;
    };
  };

  den.aspects.dev.agents.homeManager = {
    config,
    lib,
    pkgs,
    self',
    ...
  }: let
    package = self'.packages.visual-explainer;
    commandsDir = "${package.src}/plugins/visual-explainer/commands";
    commands =
      lib.mapAttrs' (file: _: lib.nameValuePair (lib.removeSuffix ".md" file) (commandsDir + "/" + file))
      (lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".md" file) (builtins.readDir commandsDir));
  in {
    home.packages = [package pkgs.nodejs pkgs.ffmpeg pkgs.chromium];

    programs.agent-skills = {
      sources.visual-explainer = {
        path = "${package}/lib/node_modules/visual-explainer";
        subdir = "plugins";
        filter.maxDepth = 1;
      };
      skills.enable = ["visual-explainer"];
    };

    programs.mcp = {
      enable = true;
      servers.visual-explainer.command = "${package}/bin/visual-explainer-mcp";
    };
    programs.claude-code.commands = lib.mkIf config.programs.claude-code.enable commands;
    programs.opencode.commands = lib.mkIf config.programs.opencode.enable commands;
  };
}
