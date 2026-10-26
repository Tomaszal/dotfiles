---
description: General operating rules and Den conventions.
applyTo: "**"
---

## Operating Rules

- Read `README.md` for setup, repository layout, and development commands.
- Keep documentation alongside what it describes, using local READMEs to link related guides instead of a separate top-level docs directory.
- Determine the active machine with `hostname`.
- Define development commands and task orchestration in Moon.
- Prefer shared aspects and defaults unless the user asks for a host-specific change.
- Use stable `pkgs` by default. Use `pkgs-unstable` only when stable does not provide the package or the user requests unstable.
- Use the NixOS MCP server for NixOS package and option lookups when available.
- When adding flake inputs, avoid duplicating dependencies already present in the flake. Use `inputs.<dependency>.follows = "<existing-input>"` for shared dependencies such as `nixpkgs`, `nixpkgs-unstable`, `flake-parts`, and other common inputs unless there is a concrete reason to keep a separate lock node.
- New files that affect Nix evaluation must be tracked or staged before running Nix commands; Git flakes cannot see completely untracked files. If staging only for evaluation, say so explicitly.
- Do not run `nix flake check` as the default validation step.
- Validate relevant system changes with `moon run repo:nixos/build`; use `-- --hostname <host>` to select another host.
- Ask before editing `facter.json`, `disko.nix`, key-related files, or user identity configuration.
- Edit repository instructions under `.apm/` and regenerate deployed files with `moon run repo:agents/sync`.

## Den Conventions

- Shared defaults usually belong under `den.default`.
- Reusable features usually belong under `den.aspects.<name>`.
- Host composition belongs in `modules/hosts/<host>/host.nix`.
- Host-specific system configuration can live in `den.aspects.<host>.nixos` or files imported by that host aspect.
- User-facing features should generally be included through `den.aspects.<host>.provides.to-users`.
- Prefer Den batteries over ad-hoc plumbing when they exist.
- For per-system flake inputs, use `inputs'.<input>.packages.<name>` or the input's per-system output shape instead of `inputs.<input>.packages.${pkgs.system}.<name>`.
- For per-system self outputs, use `self'.packages.<name>` or the relevant per-system output instead of indexing `self.packages.${pkgs.system}`.
- Request `inputs'` and `self'` from the module argument set where they are used. They may be provided by Den inside `nixos`, `homeManager`, `perSystem`, or aspect module scopes, not necessarily at the outer file scope.
- Avoid adding nixpkgs overlays just to expose a package from another flake. Prefer direct flake package references unless an overlay is explicitly needed.
- If a package is missing from stable and unstable nixpkgs, check NUR before packaging manually. Use `https://nur.nix-community.org/index.json` or `https://github.com/nix-community/nur-combined` for discovery, and prefer `github:nix-community/NUR` as the flake input.
