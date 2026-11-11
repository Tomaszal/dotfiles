# Recovery

Compare native Git state and saved Git Town state with the checkpoint before changing anything. Completed command state does not prove a multi-worktree restack finished.

## Interrupted operations

Inspect the pending program before continuation. Saved pushes, PR updates, tag pushes, or automatic stash actions can execute despite current settings; unknown operations require inspection. Continue only within the selected scope.

For local recovery, retain the checkpoint and use the active operation's matching `git rebase --abort`, `git merge --abort`, or `git cherry-pick --abort` after verifying it belongs to this restack. Inspect tips and local work afterward. Use `git town status reset` only after no Git operation remains and recovery is complete.

Treat `git town undo` as potentially remote: it can reverse hosting actions and delete branches. Its dry-run environment flag does not make undo read-only.

## Stale or missing boundaries

When the direct parent is already ancestral to the child, a fresh offline sync with rebase strategy, `--detached`, and `--no-push` can establish a baseline without changing tips. Offline merge strategy can still integrate tracking history. If completed state is stale, verify no operation is pending, preserve that checkout's Git Town state directory, and use native `git town status reset` before establishing the fresh baseline. Reset removes both `runstate.json` and `runlog.json`; preserve both. Verify all relevant branch tips remain unchanged.

If the child diverged without a usable boundary, establish the original cutoff from recorded tips, reflogs, and feature contributions. A common ancestor alone is insufficient. Pause if the evidence is ambiguous.

With a proven cutoff and authorization, use native `git rebase --onto <new-parent> <old-parent-sha> <child>` as a bounded fallback. Verify contributions, reconcile lineage, and refresh the completed baseline while the new parent is ancestral, before the next parent rewrite. Preserve local work and checkpoints throughout.
