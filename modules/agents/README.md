# Global agent configuration

Include `den.aspects.dev.agents` in a host's user aspects to enable global agent configuration.

All harnesses use the shared instructions in [instructions.md](instructions.md). Keep harness-specific settings in the corresponding module.

## Skills

Declare sources and select skills in [skills.nix](skills.nix). Upstream plugin hooks require separate configuration.

Activation removes undeclared content from managed skill directories.

## CodexBar

[CodexBar](codexbar.nix) is available at `http://127.0.0.1:8765`. Retrieve its dashboard token with `codexbar-token`. Configure providers in the harness modules; CodexBar's configuration is read-only.

## MCP setup

- [Slack MCP app registration](slack-mcp.md)
