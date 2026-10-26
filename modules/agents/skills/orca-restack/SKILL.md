---
name: orca-restack
description: Preview and restack branch stacks managed by Orca using Git Town, resume interrupted restacks, and publish when requested.
---

# Orca restack

## Rules

- Use Orca through the `orca-cli` skill for worktrees and checkpoints, and `gh` for GitHub queries and PR linking. Use Git for inspection, lineage configuration, and staging; use Git Town for sync, continuation, branch publication, and undo.
- Preserve local edits and stashes.
- Always start with a read-only preview: no fetching, config writes, generators, sync, builds, or tests. Ask what to do next and wait for the answer, using the harness's question UI when available.
- Restack locally by default. Force pushes, new branch publication, and commit creation or amendment require explicit authorization. Describe required permissions in the offered choices; the selected choice authorizes that scope without another confirmation.

## Keep execution compact

- Reuse loaded instructions and the current preview. Before execution, recheck tips, status, and pending operations; inspect only what changed.
- Return only relevant inventory and runstate fields. Start commit reviews with `git range-diff --no-patch`; use targeted source diffs and `git diff --stat -- <file>` for generated files.
- Batch independent reads and each checkout's prechecks, sync, and verification. Process worktrees sequentially and stop on failure.

## 1. Discover and check for interrupted work

Use the `orca-cli` skill to identify the current worktree and list its repository's worktrees. From the selected feature, list open PRs and their bases:

```text
gh pr list --repo <owner/repo> --state open --limit 1000 --json number,headRefName,baseRefName
```

Before analysing a fresh stack, check Git Town status, pending Git operations, and any restack checkpoint in the conversation or Orca comments. Completed runstate alone does not indicate an interruption; a checkpoint may show unfinished work between Git Town operations.

For an interrupted restack, check current tips and saved boundaries against the checkpoint. Preview progress, remaining worktree order, conflicts, local work and stashes, and previously granted permissions. Ask whether to **resume**, **inspect only**, or **stop**, including any missing scope or permissions in the question. This replaces the fresh preview and question below.

Resume from the checkpoint and native state within the authorized scope. Inspection stays read-only. Pending operations block a fresh restack; never reset them to start over.

For a fresh stack, verify that the worktree inventory is complete and identify the hosting service. Select the feature root above main and all its descendants, including siblings. Normalize refs and check that Orca's parent/baseRef agrees with PR bases. Read current tips from Git.

When `gh stack` already tracks the selected branches, use `gh stack view --json` to cross-check ordering and PR state against Orca and Git. Report disagreements as blockers; do not initialize tracking during preview. Keep rebasing and sync in Git Town.

Inspect the configured main branch, remote, rebase strategy, and Git Town version. Keep hooks enabled and tag pushes disabled: `--no-push` alone permits tag pushes, so use `-c git-town.sync-tags=false` if needed. Preserve global settings.

Build one table with branch, parent, path, tip, PR, saved parent SHA, and readiness. Record staged and unstaged changes and untracked file checksums per checkout so preservation can be verified later. Discover the repository's regeneration commands.

## 2. Validate boundaries

Git Town uses the previous parent SHA from each worktree's own runstate to avoid replaying ancestor commits. `sync --stack` skips branches checked out in other worktrees; a dry run cannot establish missing state.

Read the direct parent's local SHA and relationship from completed runstate: `EndBranchesSnapshot.Branches`, falling back to `BranchInfosLastRun`. Locate it with `git town status show` and select only relevant fields. Never edit runstate or expose credentials.

Verify ancestry with `git merge-base --is-ancestor <SHA-or-parent> <child>`:

- The saved boundary belongs to this parent and is an ancestor of the child: reuse it.
- No saved boundary, but the current parent is an ancestor of the child: establish a baseline.
- No saved boundary and no child commits, with reflogs proving creation at an older tip ancestral to the current parent: align and baseline before rewriting ancestors.
- The child has diverged from its parent without a usable boundary, or saved state is inconsistent: stop; never guess a cutoff.

Recheck boundaries after worktree moves, reparenting, or branch deletion.

Present the table, local changes, blockers, and proposed actions. Ask whether to **restack locally**, **restack and publish existing PR branches**, or **stop after preview**. Offer execution only when blockers are resolved. Describe whether publication includes GitHub stack linking, along with any required commit changes or lease-protected force pushes, in the corresponding choice.

## 3. Establish only needed baselines

Register missing lineage after verifying it; stop if existing configuration disagrees:

```text
git config --local git-town-branch.<child>.parent <parent>
```

Before rewriting any parent, establish missing baselines from each affected feature's checkout:

```text
git -c git-town.offline=true town sync --detached --no-push --non-interactive
```

Verify that tips are unchanged, except children with no commits should advance exactly to their verified parent tip. Check local work and saved boundaries. Never establish a baseline after a parent rewrite; stop on unexpected changes.

## 4. Restack and resolve

Inspect unpublished main commits before syncing. Run from main's checkout, then each feature checkout from parent to child:

```text
git town sync --no-detached --no-push --non-interactive
```

Keep normal remote integration enabled. Verify that main matches the intended remote main after syncing. Check expected tips before each feature and stop on concurrent changes. After each sync, verify parent ancestry, local work, and branch contributions, then record the new tip.

Resolve source conflicts using both changes and regenerate outputs as described in section 5. Stage the resolution and run `git town continue`. Check that branch contributions and tests were preserved. If ancestor commits are replayed unexpectedly, inspect boundaries before continuing. Avoid blanket `ours` or `theirs` resolutions.

If blocked, record the worktree, parent tips, remaining order, stash status, and granted permissions in the conversation or an Orca comment. Git Town undo reverses the last command in one worktree; it cannot undo the whole stack.

## 5. Generated outputs

- Resolve source inputs, then regenerate lockfiles and generated outputs, including after clean merges. Never hand-merge generated content.
- Use documented generators and pinned tooling. Request a specific command exception only when repository policy requires it.
- If conflict markers prevent generation, seed from a relevant Git version while preserving dependency pins, then regenerate. Pause if choosing a seed requires an unresolved source or dependency decision.
- Preserve compatible resolutions and avoid broad upgrades or deduplication. Review summaries and run targeted checks; never stage ignored artifacts.
- During a rebase conflict, stage resolved inputs and regenerated outputs together before continuing.
- After a completed rebase, commit generated corrections only with authorization to create or amend commits. Otherwise preserve them and pause before processing child branches or publishing.

## 6. Validate and optionally publish

Verify the full ancestry chain, branch contributions, generated files, and restored local work. Run the repository's documented checks once from the selected feature; repeat only after further changes or failures. Report blocked checks separately from completed history changes. Stop before publishing if validation fails.

When authorized, publish existing tracking branches from parent to child:

```text
git town sync --no-detached --push --non-interactive
```

Keep hooks and lease protection enabled. Publish local-only branches only when requested. If publication integrates remote changes that rewrite a parent, restack and revalidate its descendants before publishing them. Verify remote and PR tips afterward.

If the publication plan includes GitHub stack linking, link existing PRs from parent to child:

```text
gh stack link --base <main-branch> <parent-pr-url> <child-pr-url> ...
```

Pass PR URLs: branch-name arguments can push branches and create PRs. Link only compatible linear chains; report branching or conflicting stack membership instead of changing lineage to fit. Verify stack membership and PR bases afterward. Linking does not require local `gh stack` tracking.

Report main's SHA, updated branches and PRs, validation results, preserved local work, and blockers. Update the Orca checkpoint to reflect completion or remaining work.
