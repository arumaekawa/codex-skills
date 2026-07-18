# AGENTS.md

## Important Principles

Unless explicitly instructed by the user, **do not make edits to the code**.
Follow existing patterns in the repository, but favor clear, maintainable implementations over minimal patches that add incidental helpers or special cases.
Keep changes focused and easy to review, and include small supporting refactors when they simplify the design.

**Think in English**, and provide the final **output in Japanese**.
Write code comments in English, but provide explanations to the user in Japanese.

## Project Setup

**AGENTS.md template**
If `AGENTS.md` does not exist in the repository, copy the template from `~/.codex/templates/AGENTS.md` and customize it based on the repository's README, docs, configs, and existing files.
Do not include personal agent preferences or workflow settings in project `AGENTS.md` files, such as language preferences or ExecPlan usage rules.

**Agent workspace**
Use `.agent-work/` for all agent work, including ExecPlans, task notes, and temporary files. Do not modify the repository root `.gitignore` file. If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`.

## Development Workflows

- Use `plan-driven-development` skill for complex, long-running development work that requires multiple coordinated tasks, dependent phases, or continuation across sessions. Use it to create and maintain the overall ExecPlan.
- Use `implementation-workflow` for each cohesive, non-trivial code implementation task, including those within an ExecPlan; apply explicitly specified, self-evident minimal edits directly.

## Subagent Policy

- Unless the user explicitly prohibits subagent use, proactively use subagents whenever delegation would help. Assign self-contained tasks to subagents to keep the main agent’s context focused on coordination, evaluation, and decisions.
- Run multiple subagents in parallel only for independent, non-overlapping tasks with no conflicting changes or ordering dependencies.

## Coding Guidelines

- Prefer direct, readable changes over premature abstraction.
- Extract helpers only when they remove meaningful duplication, clarify a named domain concept, or match an existing local pattern.
- Do not add compatibility layers, fallback behavior, broad input handling, or silent recovery unless the user explicitly asks for it or the existing contract requires it.
- For research or experimental code, fail fast with clear errors on unsupported states instead of guessing or silently continuing.
- When modifying existing code, improve the surrounding structure directly when that is clearer than adding side helper paths.

## Documentation

### Use Knowledge

Before non-trivial work, consult relevant knowledge in:

- Project Wiki: `docs/wiki/`
- Personal Wiki: `~/agent-wiki/wiki/`

Treat wiki knowledge as context. Prefer current repository evidence, tests, authoritative sources, and explicit user instructions when they conflict.

### Capture Knowledge

Use `$write-project-wiki` when durable project-specific knowledge is discovered.

Use `$write-personal-wiki` to evaluate knowledge for cross-project reuse and capture eligible findings.
