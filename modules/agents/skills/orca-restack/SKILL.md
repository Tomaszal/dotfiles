---
name: orca-restack
description: Preview and restack Orca branch stacks, resume interrupted restacks, and publish validated branches when requested.
---

# Orca restack

Use `orca-cli` for workspace inventory and checkpoints, Git Town for local sync, Git for inspection and exact-tip publication, and `gh` for PRs. Reuse loaded instructions and the current preview.

## 1. Preview and choose

Keep preview read-only: use cached refs, existing Git configuration, and saved runstate. Git Town commands can migrate configuration even during inspection; read existing state files under the platform's Git Town config directory directly. Select only relevant branch snapshots, lineage, and pending operations; runstate may contain credentials.

From the current feature, select the root above main and all descendants, including siblings. Cross-check Orca's worktree inventory and parent/baseRef against Git and open PR bases. Query PRs once with `gh pr list --repo <owner/repo> --state open --limit 1000 --json number,headRefName,baseRefName`. Cross-check `gh stack view --json` only when already tracking these branches.

Read each checkout's direct-parent SHA from completed runstate: `EndBranchesSnapshot.Branches`, falling back to `BranchInfosLastRun`. Verify its saved lineage and ancestry, then review the proposed replay range against feature contributions. An ancestral SHA can still be an obsolete cutoff. Read [recovery.md](references/recovery.md) for pending operations, inconsistent state, or missing boundaries after parent divergence.

Present one compact table of branch, parent, path, tip, PR, saved boundary, and readiness. Include staged/unstaged/untracked work, tracking divergence, pending operations, and affected leaf tips. Discover documented environment, generators, checks, and policy exceptions now. Cached remote refs do not establish current remote readiness.

For an explicit preview-only request, return the preview and finish. Otherwise ask once and wait: **restack locally**, **restack and publish existing PR branches** when applicable, or **stop**. For interrupted work, offer **resume**, **inspect only**, or **stop** against the checkpoint. Include known generator/staging exceptions, generated-file commit amendments, force pushes, and optional GitHub stack linking in the relevant choice. Carry granted scope forward; ask again only for new decisions.

## 2. Prepare

Enter the documented development environment. Recheck tips, local work, and pending operations against the preview; inspect only changes.

Start affected checkouts clean so Git Town cannot flatten staged/unstaged work through automatic stashing. Preserve dirty work with `git stash push --include-untracked -m <unique-marker>`. Record that marker's exact OID from `git stash list --format='%H %gs'` and the original staged/unstaged selection. Stashes are shared across worktrees. Keep work stashed through committed-tip validation and publication; restore afterward with `git stash apply --index <OID>`, retaining the backup until preservation is verified.

Register missing lineage only after Orca, Git history, and PR bases agree: `git config --local git-town-branch.<child>.parent <parent>`. Existing disagreement requires a reparenting decision.

Before rewriting any parent, establish missing baselines from feature checkouts where the current direct parent is already ancestral. In the local sync command below, replace `--no-detached` with `--detached` and add `-c git-town.offline=true`; verify tips remain unchanged. Refresh stale completed state as described in [recovery.md](references/recovery.md), rather than reusing its obsolete cutoff.

## 3. Restack locally

Process main's checkout, then feature checkouts parent first. Keep each ancestor in its own checkout; Git Town can otherwise process it again during a child sync. `sync --stack` skips branches checked out elsewhere. Fetch without tags, inspect unpublished main commits and tracking divergence, and preserve genuine remote-only work. Recheck expected tips before each operation.

Use explicit command-scoped settings so repository overrides cannot enable hosting writes:

```sh
git -c git-town.proposal-breadcrumb=none -c git-town.sync-tags=false -c git-town.push-hook=true -c git-town.sync-feature-strategy=rebase town sync --no-detached --no-push --non-interactive
```

Verify main matches its intended remote. For features whose tracking refs contain proven old published history after local rewrites, obtain the local-authoritative choice before adding `-c git-town.offline=true`; sync main first. Record the verified tips in the checkpoint. A normal sync can otherwise replay that old remote history.

After each sync, verify parent ancestry and feature contributions. Start with `git range-diff --no-patch`, inspect changed source patches, and summarize generated files with `git diff --stat`. Record the new tip.

Resolve source conflicts from both changes, then regenerate affected outputs with documented commands and pinned tools. Preserve dependency pins; if conflict markers prevent generation, seed generated content from a relevant Git version before regenerating. Ask when the seed requires an unresolved source or dependency decision. Stage resolved inputs and outputs together. Inspect pending operations before `git town continue` with the same command-scoped settings; flags do not remove hosting writes already queued by an older command.

Regenerate affected outputs after clean merges too. Create or amend commits only within the selected scope; otherwise retain corrections and pause before descendants or publication. Review merge behavior that patch preservation and static checks cannot establish.

If blocked, record current worktree, old/new parent tips, remaining order, stash OIDs, and permissions in the conversation or Orca checkpoint. Use [recovery.md](references/recovery.md) for local recovery.

## 4. Validate and publish

Validate clean committed tips. Run broad repository checks at every affected leaf, deduplicating identical tips; keep targeted checks for conflicts and independently published intermediate commits. Repeat after changed inputs or failures. Stop publication on validation or semantic blockers.

For authorized publication, match existing upstream destinations to the selected PR heads, distinct from main and ancestor destinations. Verify required parent publication first. Recheck the validated local SHA and recorded remote SHA, then push exactly that commit with hooks enabled:

```sh
git -c push.followTags=false -c push.recurseSubmodules=no push --force-with-lease=refs/heads/<remote-branch>:<recorded-remote-sha> <remote> <validated-sha>:refs/heads/<remote-branch>
```

Publish parent first. A failed lease requires inspection and revalidation of integrated changes. This avoids another sync changing a commit after validation. New branch publication requires its own authorization.

If authorized, link compatible linear chains with `gh stack link --base <main> <parent-pr-url> <child-pr-url> ...`. Use PR URLs; branch arguments can push and create PRs. Verify remote tips, PR bases, and stack membership afterward.

Restore local work with `git stash apply --index <OID>`, verify staged/unstaged separation, untracked content, and original stashes, and review restoration conflicts. Report main's SHA, changed branches/PRs, validation, preserved work, retained backups, and blockers. Update the Orca checkpoint.
