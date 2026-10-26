# Connect Slack to Executor

Add `https://mcp.slack.com/mcp` as an integration in the Executor dashboard and configure the account there.

Create an internal Slack app from a manifest to add the required user-token scopes in one step. In [Your Apps](https://api.slack.com/apps), select **Create New App** -> **From an app manifest**, choose a workspace, and paste:

```yaml
_metadata:
  major_version: 1

display_information:
  name: MCP Client

oauth_config:
  redirect_urls:
    - https://client.example.com/oauth/callback
  scopes:
    user:
      - search:read.public
      - search:read.private
      - search:read.mpim
      - search:read.im
      - search:read.files
      - files:read
      - emoji:read
      - search:read.users
      - chat:write
      - channels:history
      - groups:history
      - mpim:history
      - im:history
      - channels:write
      - groups:write
      - im:write
      - mpim:write
      - reactions:write
      - canvases:read
      - canvases:write
      - users:read
      - users:read.email
      - channels:read
      - groups:read
      - mpim:read

settings:
  is_mcp_enabled: true
```

Then:

1. Replace the example redirect URL with the exact callback URL shown by Executor.
2. Install or reauthorize the app for the workspace.
3. Enter the app's Client ID and Client Secret from **Basic Information** into Executor's account setup, then complete the Slack authorization flow.

Only internal or Marketplace-published apps can access Slack MCP. Remove write scopes that the client does not need.

## Sources

- [Slack app manifest reference](https://docs.slack.dev/reference/app-manifest)
- [Slack MCP app setup](https://docs.slack.dev/ai/slack-mcp-server/developing)
