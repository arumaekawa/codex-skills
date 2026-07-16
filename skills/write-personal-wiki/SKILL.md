---
name: write-personal-wiki
description: Evaluate and capture durable cross-project knowledge in the personal wiki. Use when work reveals knowledge that may be reusable across repositories, including technical knowledge, general workflows, cross-project gotchas, external research, and non-sensitive internal R&D knowledge.
---

# Write Personal Wiki

Use this skill to evaluate discovered knowledge and document eligible findings in the personal wiki.

Use `~/agent-wiki/wiki/` unless existing instructions specify otherwise.

## Workflow

1. Review the knowledge discovered or documented during the task.
2. Identify findings that are useful beyond one project.
3. Exclude transient, sensitive, or narrowly project-specific information.
4. Remove unnecessary source-project details while preserving essential context.
5. Integrate the finding into an existing page when possible.
6. Otherwise, create a concise page in the appropriate category.
7. Update `wiki/index.md` when adding an important page.
8. Check links, accuracy, reusability, and safety.

## Personal Wiki

Use the existing personal wiki conventions when available.

The default structure is:

```text
wiki/
  index.md
  knowledge/
  workflows/
  gotchas/
  internal/
```

Classify content as follows:

- `knowledge/`: Reusable technical or domain knowledge, APIs, SDK usage, data formats, research, implementation patterns, and coding conventions.
- `workflows/`: General development, testing, benchmarking, evaluation, deployment, release, and operational procedures.
- `gotchas/`: Cross-project pitfalls, external API quirks, environment issues, non-obvious constraints, nondeterminism, and rate limits.
- `internal/`: Non-sensitive internal R&D knowledge shared across projects, such as implementation intent, model design, internal interfaces, reusable experimental findings, and relationships between internal systems.

## What To Capture

Document knowledge when it is likely to help across repositories or future projects.

Good candidates:

- External research from primary sources, with URL, access date, version, and concise reusable conclusions.
- Reusable API, SDK, data format, configuration, and implementation knowledge.
- General AI/ML workflows involving datasets, training, evaluation, metrics, inference, and artifacts.
- Development workflows and gotchas that apply across projects.
- Non-sensitive internal R&D knowledge that helps transfer implementation intent or findings between projects.

Capture a finding only when it is:

- Useful beyond the current project or task.
- Stable enough to remain useful.
- Safe to retain in the personal wiki.
- Understandable with the context preserved in the page.

Do not document:

- Secrets, credentials, tokens, private data, or sensitive project information.
- Raw logs, temporary errors, or transient task progress.
- One-off project details with no cross-project value.
- Information already documented adequately in an existing page.
- Speculation unsupported by repository evidence or cited sources.

## Editing Rules

Keep updates small, factual, self-contained, and easy to review.

Prefer updating existing pages over creating duplicates. Use descriptive kebab-case filenames for new pages.

Remove unnecessary project-specific names and context from general categories. Preserve necessary internal context only under `internal/`.

Prefer concise summaries over copied text. Link to sources instead of reproducing large amounts of source content.

When uncertain whether a finding belongs in the personal wiki, do not write it automatically and report the question to the user.
