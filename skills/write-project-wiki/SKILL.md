---
name: write-project-wiki
description: Capture durable project-specific knowledge in the project wiki. Use when work reveals reusable specifications, repository architecture, APIs, data formats, project workflows, research findings, or gotchas that should remain available to future contributors.
---

# Write Project Wiki

Use this skill to document reusable project-specific knowledge discovered during work.

Prefer existing repository instructions and wiki structure. If none exists, use the defaults below.

## Workflow

1. Identify durable knowledge worth preserving in the project.
2. Exclude transient status, raw logs, secrets, private data, and one-off task notes.
3. Integrate the finding into an existing page when possible.
4. Otherwise, create a concise page in the appropriate category.
5. Update the wiki index when adding an important page.
6. Check links, accuracy, and readability.

## Project Wiki

Use the repository's existing wiki conventions when available.

If no structure exists, use:

```text
docs/wiki/
  index.md
  specs/
  knowledge/
  workflows/
  gotchas/
```

Classify content as follows:

- `specs/`: Intended component behavior, requirements, constraints, implementation specifications, and relevant design rationale.
- `knowledge/`: Project architecture, APIs, SDK usage, data formats, configs, domain knowledge, related research, and implementation patterns.
- `workflows/`: Development, setup, testing, benchmarking, experimentation, evaluation, deployment, release, and operational procedures.
- `gotchas/`: Pitfalls, surprising behavior, environment issues, non-obvious constraints, flaky behavior, nondeterminism, and rate limits.

Record durable decisions and tradeoffs in the relevant specification instead of using a separate `decisions/` category.

## What To Capture

Document knowledge when it is likely to help future work in the project.

Good candidates:

- Intended component behavior, requirements, constraints, and design rationale.
- Repository architecture, APIs, data/model formats, configs, and implementation patterns.
- External research from primary sources, with URL, access date, version, and a concise project-relevant summary.
- AI/ML knowledge and workflows involving datasets, schemas, splits, prompts, training, evaluation, metrics, baselines, and artifacts.
- Development workflows and gotchas involving tools, tests, demos, deployment, CUDA, checkpoints, tokenizers, nondeterminism, or rate limits.

Do not document:

- Secrets, credentials, tokens, private data, or sensitive information.
- Raw logs, temporary errors, or transient task progress.
- One-off implementation details unlikely to help future work.
- Information already clear from nearby documentation unless the wiki adds useful structure or context.
- Speculation unsupported by repository evidence or cited sources.

## Editing Rules

Keep updates small, factual, and easy to review.

Prefer updating existing pages over creating duplicates. Use descriptive kebab-case filenames for new pages.

Prefer concise summaries over copied text. Link to sources instead of reproducing large amounts of source content.
