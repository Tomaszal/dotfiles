{
  den.aspects.dev.opencode.homeManager = {
    config,
    lib,
    pkgs,
    pkgs-mv,
    ...
  }: let
    # Home Manager's OpenCode MCP integration currently omits OAuth settings.
    # These complete per-server overrides preserve them; MCP entries merge shallowly.
    oauthMcpServers =
      lib.mapAttrs (
        _: server: let
        in
          lib.optionalAttrs (server.enabled or null != null) {inherit (server) enabled;}
          // {
            type = "remote";
            inherit (server) url oauth;
          }
          // lib.optionalAttrs (server.headers or {} != {}) {inherit (server) headers;}
      )
      (lib.filterAttrs (
          _: server: server ? url && server.url != null && builtins.isAttrs (server.oauth or null)
        )
        config.programs.mcp.servers);
  in {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings.mcp = oauthMcpServers;
      package = pkgs.writeShellApplication {
        name = "opencode";
        text = ''
          ${config.programs.mcp.wrapperHooks}
          ${lib.getExe pkgs-mv.tip.opencode} "$@"
        '';
      };
    };

    programs.mcp.enable = true;
  };
}
