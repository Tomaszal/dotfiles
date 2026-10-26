{inputs, ...}: {
  den.aspects.dev.agents.opencode.homeManager = {pkgs-mv, ...}: {
    # TODO(NixOS 26.11): Use the release module; remove this override and inputs argument.
    # OpenCode 2 CLI support: https://github.com/nix-community/home-manager/pull/10105
    disabledModules = ["programs/opencode.nix"];
    imports = ["${inputs.home-manager-unstable}/modules/programs/opencode.nix"];

    programs.opencode = {
      enable = true;
      mutableSettings = true;
      validateFiles.cli = true;
      context = ../instructions.md;
      enableMcpIntegration = true;
      package = with pkgs-mv.tip; opencode;
      cli.tabs.mode = "off";

      settings.permission = {
        external_directory."/nix/store/**" = "allow";
        read."/nix/store/**" = "allow";
        list."/nix/store/**" = "allow";
      };

      cli.keybinds = {
        "command.palette.show" = "ctrl+o";
        "open.menu" = "none";
        "session.first" = "none";
        "session.last" = "none";
        "input.line.home" = "home";
        "input.line.end" = "end";
        "input.buffer.home" = "ctrl+home";
        "input.buffer.end" = "ctrl+end";
      };
    };

    programs.agent-skills.targets.opencode.enable = true;
  };
}
