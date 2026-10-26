# Global agent configuration

Include `den.aspects.dev.agents` in a host's user aspects to enable global agent configuration.

All harnesses use the shared instructions in [instructions.md](instructions.md). Keep harness-specific settings in the corresponding module.

Claude and Codex settings remain editable; repository defaults take precedence over local changes.

## Skills

Declare sources and select skills in [skills.nix](skills.nix). Upstream plugin hooks require separate configuration.

Activation removes undeclared content from managed skill directories.

## CodexBar

[CodexBar](codexbar.nix) is available at `http://127.0.0.1:8765`. Retrieve its dashboard token with `codexbar-token`. Configure providers in the harness modules; CodexBar's configuration is read-only.

## Integrations

Manage shared connections and accounts in the [Executor dashboard](http://127.0.0.1:4788), or use the `executor` CLI.

- [Connect Figma](figma-mcp.md)
- [Register a Slack app](slack-mcp.md)
