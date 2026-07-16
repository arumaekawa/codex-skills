# AGENTS.md

Shared guidance for agents working in this repository. Keep personal preferences outside this repo.

<!--
Fill this template by reading repo sources first: README.md, CONTRIBUTING.md, docs/, pyproject.toml, package.json, Cargo.toml, Makefile/justfile, .github/workflows/, .gitignore, and existing tests. Replace {{...}} placeholders, remove irrelevant examples, and delete this comment.
-->

## Repository

{{REPOSITORY_SUMMARY: Summarize the repo in 1-3 sentences from README.md/docs.}}

{{IMPORTANT_PATHS: Describe the important directories and generated-artifact paths. Mention only paths that actually exist or are documented in this repository.}}

## Rules

- Keep changes focused, maintainable, and aligned with the repository's design.
- Prefer straightforward implementations over narrow patches that add incidental helpers or special cases.
- Follow existing patterns before adding new structure; document intentional departures.
- Do not modify generated files, large artifacts, data, logs, or unrelated files unless explicitly required.
- Never commit secrets, credentials, API keys, tokens, or private data.

{{REPO_SPECIFIC_RULES: Add only repository-specific boundaries, artifact rules, or security constraints. Remove this placeholder if none are documented.}}

## Commands

{{COMMANDS: Derive canonical setup, test, lint, format, typecheck, and run commands from README, manifests, Makefile/justfile, and CI. Keep only commands that apply to this repository.}}

## Validation

- After code changes, run the smallest useful validation set for the affected area.
- If validation cannot be run because of credentials, GPUs, external services, large datasets, or expensive full runs, state that clearly.
- Review the final diff for bugs, regressions, risky patterns, and unrelated changes before reporting completion.

{{VALIDATION: State required checks from README, test configs, and CI. Include manual smoke tests for user-facing changes when needed.}}

## Conventions

{{CONVENTIONS: Document only repo-specific code/test conventions discovered from configs and existing files: layout, naming, formatting, linting, typing, fixtures, mocking, async tests, coverage, data/model artifacts.}}

## Documentation

Before non-trivial work, consult relevant knowledge in `docs/wiki/` when available.

Treat wiki knowledge as context. Prefer current repository evidence, tests, authoritative sources, and explicit user instructions when they conflict.

Add reusable project knowledge discovered during work to `docs/wiki/`.

Use this structure:

```text
docs/wiki/
  index.md      # Entry point and links to important pages

  specs/        # Intended behavior, requirements, constraints, and design rationale
  knowledge/    # Architecture, APIs, data formats, domain knowledge, research, and implementation patterns
  workflows/    # Development, testing, benchmarking, experimentation, deployment, and release procedures
  gotchas/      # Pitfalls, surprising behavior, environment issues, and non-obvious constraints
```

Add knowledge when it is likely to help future work:

- Intended component behavior, requirements, constraints, and design rationale.
- External research from primary sources, with URL, access date, version, and summary.
- Repository architecture, APIs, data/model formats, configs, and implementation patterns.
- AI/ML workflows involving datasets, schemas, splits, prompts, training, evaluation, metrics, baselines, and artifacts.
- Development workflows and gotchas involving tools, tests, demos, deployment, CUDA, checkpoints, tokenizers, nondeterminism, and rate limits.

Record durable decisions and tradeoffs in the relevant specification.

Do not document transient task status, raw logs, secrets, credentials, private data, or unsupported speculation.
