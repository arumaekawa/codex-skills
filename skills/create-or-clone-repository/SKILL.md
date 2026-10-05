---
name: create-or-clone-repository
description: Create or clone Git repositories into the configured ghq layout. Use whenever a task requires initializing a new repository or obtaining a local clone, before choosing a directory or running git init or git clone.
---

# Create or Clone Repository

Use ghq so repositories follow the configured root and host/owner/repository layout.
Do not choose an arbitrary clone directory or use `git init` or `git clone` directly
unless the user explicitly requests a different location or method.

- Confirm the repository identity and check `ghq list -p` for an existing clone. Reuse it when available; do not relocate an existing repository.
- Clone a remote repository with `ghq get -p HOST/OWNER/REPOSITORY` (SSH), or `ghq get URL` when a specific URL is provided.
- Create a new local repository with `ghq create HOST/OWNER/REPOSITORY`. If the identity is unknown, ask rather than inventing a host or owner.
- Resolve the resulting path with `ghq list -p -e HOST/OWNER/REPOSITORY` and run subsequent commands there.

`ghq create` does not create a hosted repository or configure `origin`. When worktrees
are needed, register the intended remote URL and make the initial commit first.
