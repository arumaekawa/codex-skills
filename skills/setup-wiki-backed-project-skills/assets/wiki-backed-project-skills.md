# Wiki-backed project skills

Use this pattern when an agent should reliably discover a reusable project
workflow without duplicating its instructions in `SKILL.md`.

## Request the work

```text
Document <workflow> in docs/wiki/workflows and add a repository skill that
selects this workflow from user intent. Keep the procedure canonical in the
wiki and make SKILL.md a thin pointer.
```

Tell the agent any required skill name or wiki filename. Otherwise, it should
choose short, descriptive kebab-case names that match repository conventions.

## Agent procedure

Read the repository's AGENTS.md and documentation conventions first. Use this
workflow only when `docs/wiki` is already used as the project wiki or AGENTS.md
prescribes it; create missing directories in the latter case. If instructions
conflict with this convention or its adoption is unclear, explain the issue
and stop without changing the documentation structure.

Follow repository naming and skill placement conventions, adjusting the
paths and relative links below as needed.

1. Check `docs/wiki/` and `.agents/skills/` for an existing workflow or skill
   and update it instead of creating a duplicate.
2. Write the complete, reusable procedure in
   `docs/wiki/workflows/<workflow-name>.md`.
3. Add the workflow to the wiki index, creating it if needed.
4. Add `.agents/skills/<skill-name>/SKILL.md` using the format below.
5. Validate the skill, resolve its relative wiki link, and run
   `git diff --check`.

The wiki must contain enough inputs, commands, decisions, verification, and
safe resume guidance for another contributor to ask an agent to perform the
work. Exclude task status, job IDs, raw logs, credentials, private data,
personal paths, and one-off monitoring schedules.

## Skill format

```markdown
---
name: run-example-workflow
description: Run the repository's example workflow. Use when ...
---

# Run Example Workflow

## When to use

Use this skill when running, preparing, repairing, or verifying the example
workflow.

## Procedure

Read [example workflow](../../../docs/wiki/workflows/example.md).
```

The frontmatter `description` determines automatic discovery. Keep the body to
the `When to use` and `Procedure` sections. Commands, options, authorization
rules, examples, recovery steps, and troubleshooting belong only in the wiki.

## Completion criteria

- The wiki page is usable without reading `SKILL.md`.
- The skill selects the intended requests without catching unrelated tasks.
- The skill contains no copy of the operational procedure.
- The wiki index and relative skill link resolve.
- The bundled skill validator passes when available.
