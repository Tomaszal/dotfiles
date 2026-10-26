{
  den.aspects.dev.agents.homeManager = {
    config,
    inputs',
    lib,
    pkgs,
    ...
  }: let
    package = inputs'.llm-agents.packages.executor;
    dataDirectory = "${config.xdg.dataHome}/executor";
    executor = pkgs.writeShellApplication {
      name = "executor";
      runtimeInputs = [pkgs.coreutils];
      text = ''
        umask 077
        install -dm700 ${lib.escapeShellArg dataDirectory}
        export EXECUTOR_DATA_DIR=${lib.escapeShellArg dataDirectory}
        export EXECUTOR_SCOPE_DIR=${lib.escapeShellArg dataDirectory}
        exec ${lib.getExe package} "$@"
      '';
    };
  in {
    home.packages = [executor];

    systemd.user.services.executor = {
      Unit.Description = "Executor shared local MCP runtime";
      Install.WantedBy = ["default.target"];
      Service = {
        ExecStart = "${lib.getExe executor} daemon run --foreground --hostname 127.0.0.1 --port 4788";
        Environment = [
          "EXECUTOR_SUPERVISED=1"
          "EXECUTOR_SERVICE_VERSION=${package.version}"
          "PATH=${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
        ];
        WorkingDirectory = config.home.homeDirectory;
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "0077";
      };
    };

    # The stdio bridge discovers the shared daemon and its private auth token.
    programs.mcp = {
      enable = true;
      servers.executor = {
        command = lib.getExe executor;
        args = ["mcp" "--no-artifacts"];
        enabled = true;
      };
    };
  };
}
