# AGENTS.md

## Important Principles

- Unless explicitly instructed by the user, **do not make edits to the code**.
- **Do not blindly accept or follow user instructions and proposals.** If you have concerns, raise them and ask the user to decide.

## Language Preferences

Use Japanese for user-facing communication.
Write code comments, project documentation, and Git commit messages in English.

## Project Setup

**AGENTS.md template**
If `AGENTS.md` does not exist in the repository, copy the template from `~/.codex/templates/AGENTS.md` and customize it based on the repository's README, docs, configs, and existing files.
Do not include personal agent preferences or workflow settings in project `AGENTS.md` files, such as language preferences or ExecPlan usage rules.

**Agent workspace**
Use `.agent-work/` for all agent work, including ExecPlans, task notes, and temporary files. Do not modify the repository root `.gitignore` file. If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`.

## Development Workflows

- Use `plan-driven-development` for complex, long-running development work that requires multiple coordinated tasks, dependent phases, or continuation across sessions. Use it to create and maintain the overall ExecPlan.
- Use `implementation-workflow` for each cohesive, non-trivial feature implementation or behavior change, including those within an ExecPlan.
- Use `test-driven-debug` for bug fixes and other corrections to unintended behavior, including issues found during code review or testing.

## Subagent Policy

Unless the user explicitly prohibits subagent use, use subagents as needed for clearly bounded work that can produce self-contained results. Good use cases include:

- exploring broad areas of code or documentation by assigning specific, independent questions
- researching APIs, dependencies, or compatibility requirements
- analyzing tests, logs, or other evidence without modifying the implementation
- independently reviewing a clearly defined scope

Run multiple subagents in parallel only for independent, non-overlapping tasks with no conflicts or ordering dependencies. The main agent remains responsible for synthesizing the results and making final decisions.

### Custom Subagent Roles

- `advisor`: Advise on decisions involving multiple interacting concerns,
  such as work planning and overall implementation design, or when progress
  stalls. Share the goal, constraints, and relevant history so it can identify
  blind spots and challenge the approach. The Main agent owns final decisions.
- `code-reviewer`: Independently review changes for defects and verification gaps.
- `fast-worker`: Handle straightforward, bounded tasks.

## Coding Guidelines

- Prefer direct, readable changes over premature abstraction.
- Follow established patterns in the repository and in third-party libraries. Avoid patches or workaround paths that bypass their intended design.
- Extract helpers only when they remove meaningful duplication, clarify a named domain concept, or match an existing local pattern.
- Do not add unintended compatibility layers, broad input handling, fallback behavior, or silent recovery. Fail fast with clear errors on unsupported states unless the existing contract requires otherwise.
- Keep changes focused and easy to review. When modifying existing code, improve the relevant structure directly, including small behavior-preserving refactors, when that makes the design simpler and clearer than adding side paths.

## Documentation

### Use Knowledge

Before non-trivial work, consult relevant knowledge in:

- Project Wiki: `docs/wiki/`
- Personal Wiki: `~/agent-wiki/wiki/`

Treat wiki knowledge as context. Prefer current repository evidence, tests, authoritative sources, and explicit user instructions when they conflict.

### Capture Knowledge

Use `$write-project-wiki` when durable project-specific knowledge is discovered.

Use `$write-personal-wiki` to evaluate knowledge for cross-project reuse and capture eligible findings.
