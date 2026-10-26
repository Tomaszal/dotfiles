{
  den.aspects.dev.agents.homeManager = {
    config,
    inputs',
    lib,
    pkgs,
    ...
  }: let
    orca = inputs'.llm-agents.packages.orca;
    workspaces = "${config.home.homeDirectory}/orca/workspaces";
    # Use the same source commit as Orca's native installer, without a second pin.
    metadata = builtins.fromJSON (builtins.readFile "${orca}/lib/Orca/resources/app.asar.unpacked/out/package.json");
    source = builtins.fetchTree {
      type = "github";
      owner = "stablyai";
      repo = "orca";
      rev = metadata.commit;
    };
  in {
    home.packages = [orca] ++ lib.optionals config.programs.codex.enable [pkgs.bubblewrap];

    programs.agent-skills = {
      sources.orca = {
        path = source.outPath;
        subdir = "skills";
      };
      skills.enableAll = ["orca"];
    };

    # Orca's CLI discovery checks the symlink target against its bundled shim.
    systemd.user.tmpfiles.rules = [
      "d %h/.local/bin 0755 - - -"
      "L+ %h/.local/bin/orca-ide - - - - ${orca}/lib/Orca/resources/bin/orca-ide"
    ];

    # direnv matches literal path prefixes, so retain the separator.
    programs.direnv.config.whitelist.prefix = ["${workspaces}/"];

    # Codex needs workspace-write for additional roots and network access for
    # the local Orca bridge. Keep approval requests available for escalations.
    programs.codex.settings = lib.mkIf config.programs.codex.enable {
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write = {
        writable_roots = [workspaces];
        network_access = true;
      };
    };

    programs.claude-code.settings = lib.mkIf config.programs.claude-code.enable {
      permissions = {
        additionalDirectories = [workspaces];
        # Claude's // prefix denotes an absolute filesystem path.
        allow = map (tool: "${tool}(/${workspaces}/**)") ["Read" "Edit" "Write"];
      };
    };

    programs.opencode.settings = lib.mkIf config.programs.opencode.enable {
      permission.external_directory."${workspaces}/**" = "allow";
    };
  };
}
