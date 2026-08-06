{den, ...}: {
  den.aspects.collaboration = {
    includes = [(den.batteries.unfree ["slack"])];

    homeManager = {pkgs-unstable, ...}: {
      programs.mcp.servers.linear = {
        url = "https://mcp.linear.app/mcp";
        enabled = true;
        oauth = true;
      };

      programs.mcp.servers.notion = {
        url = "https://mcp.notion.com/mcp";
        enabled = true;
        oauth = true;
      };

      programs.mcp.servers.slack = {
        url = "https://mcp.slack.com/mcp";
        enabled = true;
        oauth = {
          clientId = "{env:SLACK_MCP_CLIENT_ID}";
          clientSecret = "{env:SLACK_MCP_CLIENT_SECRET}";
        };
      };

      programs.mcp.wrapperHooks = ''
        if [ -r "$HOME/.config/slack-mcp.env" ]; then
          # shellcheck disable=SC1091
          . "$HOME/.config/slack-mcp.env"
        fi
      '';

      home.packages = with pkgs-unstable; [slack];
    };
  };
}
