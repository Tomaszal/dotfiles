# Connect Figma to Executor

These steps apply to Executor 1.6.10. In Executor's dashboard, add `https://mcp.figma.com/mcp` as an MCP integration if it is not already present.

## Register the app

Run the following command. Keep the `redirectUri` exactly as shown in both commands below: Figma rejects registering `/api/oauth/callback` directly.

```sh
executor call executor coreTools oauth clients registerDynamic '{
  "owner": "user",
  "slug": "figma-executor",
  "issuer": "https://api.figma.com",
  "registrationEndpoint": "https://api.figma.com/v1/oauth/mcp/register",
  "authorizationUrl": "https://www.figma.com/oauth/mcp",
  "tokenUrl": "https://api.figma.com/v1/oauth/token",
  "resource": "https://mcp.figma.com/mcp",
  "scopes": ["mcp:connect"],
  "tokenEndpointAuthMethodsSupported": [
    "client_secret_basic",
    "client_secret_post"
  ],
  "clientName": "Executor",
  "redirectUri": "http://localhost:4788/callback",
  "originIntegration": "figma_com_mcp"
}'
```

The command prints an approval request and exits. Under **CLI fallback**, run the returned command containing `--action accept` to approve and complete registration.

Continue when the result says `ok: true`. Note the value of `data.client`; it is usually `dcr-api-figma-com`.

## Sign in to Figma

Run this command, replacing `dcr-api-figma-com` if the previous result returned a different value:

```sh
executor call executor coreTools oauth start '{
  "client": "dcr-api-figma-com",
  "clientOwner": "user",
  "owner": "user",
  "name": "figma",
  "integration": "figma_com_mcp",
  "template": "oauth2",
  "redirectUri": "http://localhost:4788/callback"
}'
```

This command also prints an approval request and exits. Under **CLI fallback**, run its returned command containing `--action accept` to approve and obtain the sign-in link.

Before opening the returned `data.authorizationUrl`, read **Finish connecting** below. You will have **30 seconds after clicking Allow access in Figma** to complete it.

Open `data.authorizationUrl` in your browser, sign in to Figma, and approve access.

## Finish connecting

Immediately after clicking **Allow access** in Figma:

1. When the browser returns to `http://localhost:4788/callback?...`, select the address bar.
2. Change **only** `/callback` to `/api/oauth/callback`. Keep everything after `?` unchanged.
3. Press Enter **within 30 seconds of approving access**. Do not wait for the page to finish loading before editing the address.

If you miss the deadline or get a token-exchange error, repeat **Sign in to Figma** with a fresh authorization link. Do not reload the failed page or register the app again.