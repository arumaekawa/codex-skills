# AGENTS.md

## Repository

This repository manages personal Codex skills, custom agents, and AGENTS.md templates.
Skills live in `skills/`, agent definitions in `agents/`, templates in `templates/`,
and installation and validation tools in `scripts/`.

## Rules

- Keep changes focused on the requested component.
- Do not commit secrets, credentials, or unrelated artifacts.
- Install skills through the native Codex plugin; repository scripts manage agents and templates.

## Commands

- Validate the repository: `./scripts/verify.sh`.
- Install agents: `./scripts/install.sh agents --link --backup`.
- Install templates: `./scripts/install.sh templates --link --backup`.
- Validate installed components: `./scripts/verify.sh --installed`.

## Validation

Run repository validation after changes and inspect the final diff.
For installation changes, verify the affected installed component as well.

## Conventions

Define custom agents as standalone TOML files in `agents/`.
Keep reusable templates separate from installed files.

## Documentation

Consult `docs/wiki/` before non-trivial work when available.
Prefer current repository evidence over stale documentation and capture durable
project knowledge there when appropriate.
