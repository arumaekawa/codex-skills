---
name: manage-git-worktrees
description: Create, reuse, inspect, and remove Git worktrees with gwq. Use whenever a task requires a separate working directory for branch work or any Git worktree operation, before choosing a worktree path or creation method.
---

# Manage Git Worktrees

- Inspect the target repository's worktrees with `gwq list` and their state with `gwq status --no-fetch`.
- Reuse a worktree for the intended branch when available.

## Create

Confirm the repository and intended starting HEAD, then run:

```sh
gwq add -b WORK_BRANCH
```

- Use `feat-am/<name>` or `fix-am/<name>` unless otherwise specified.
- For an existing branch, omit `-b`.
- Never use `HEAD` as the branch name or create a detached worktree.
- Omit the path argument; let gwq determine the layout. Do not use other worktree creation methods.
- Confirm the resulting path and branch, and run subsequent commands there.

For a different base:

```sh
git branch --no-track WORK_BRANCH BASE
gwq add WORK_BRANCH
```

## Remove

Check the target and uncommitted changes before removal:

```sh
gwq remove --dry-run PATTERN
gwq remove PATTERN
```

Preserve the branch unless deletion is intended (`-b`). Do not force removal of uncommitted work without explicit user authorization.
