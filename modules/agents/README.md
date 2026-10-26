# Global agent configuration

Include `den.aspects.dev.agents` in a host's user aspects to enable global agent configuration.

All harnesses use the shared instructions in [instructions.md](instructions.md). Keep harness-specific settings in the corresponding module.

Harness settings remain editable; repository defaults take precedence over local changes.

## Skills

Declare sources and select skills in [skills/module.nix](skills/module.nix). Upstream plugin hooks require separate configuration.

Activation removes undeclared content from managed skill directories.

## Review changes

```sh
orca-review [auto|uncommitted|committed|picker]
```

Run in an Orca worktree to review changes in its browser using [pulls.review](https://github.com/antfu/pulls.review). By default, it selects uncommitted changes when dirty, otherwise compares commits against the configured base.

Keep the command running during review; press Ctrl-C to stop the server.

## Integrations

Manage shared connections and accounts in the [Executor dashboard](http://127.0.0.1:4788), or use the `executor` CLI.

- [Connect Figma](executor/figma.md)
- [Register a Slack app](executor/slack.md)
