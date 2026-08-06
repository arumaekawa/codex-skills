---
name: task-brief
description: Clarify substantial work with a concise Task Brief when high-impact details cannot be safely inferred before planning or implementation. Use to resolve ambiguity in Goal, Context, Constraints, or Done when; ask only high-impact unknowns; and get user confirmation before continuing.
---

# Task Brief

Use this skill to clarify substantial work before writing an ExecPlan or starting implementation.

## Workflow

1. Inspect the user's request and relevant repository context.
2. Infer details that are reasonably knowable from local files, README, docs, configs, tests, errors, and existing patterns.
3. Ask only for high-impact unknowns that cannot be safely inferred.
4. Present a short Task Brief to the user.
5. Wait for user confirmation before creating an ExecPlan or beginning implementation.

## Task Brief Format

```markdown
**Task Brief**

Goal:
- ...

Context:
- ...

Constraints:
- ...

Done when:
- ...
```

## Inference Rules

Infer routine details when evidence is available.

Examples:
- Existing frameworks, package managers, test commands, and code style from repository files.
- Relevant behavior from README, docs, tests, configs, and current errors.
- Reasonable scope from the user's explicit request.

Do not invent product behavior, public API changes, data/privacy requirements, destructive operations, expensive compute, or acceptance criteria.

## Questions

Ask concise questions only when the answer materially changes the plan or risk.

Prefer 1-3 questions. Avoid asking about details that can be discovered locally or safely deferred.

## Confirmation Gate

Before creating an ExecPlan or implementing substantial work, show the completed Task Brief and ask for confirmation.

Do not print a full ExecPlan as part of the Task Brief.
Do not modify code while still clarifying the Task Brief.
