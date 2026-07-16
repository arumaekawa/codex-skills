# codex-skills

Personal Codex [skills](skills/), [custom agents](agents/), and [AGENTS.md templates](templates/)
managed as one portable Git repository.

It is designed for AI/ML development work and includes plan-driven workflows for
long-running work, collaborative implementation with subagents, and guardrails
against over-engineering.

## Overview

The skills form a layered development workflow:

- `task-brief` defines the task with the user before execution.
- `plan-driven-development` coordinates long-running work as phases and bounded tasks.
- `implementation-workflow` carries one bounded code task with subagents
  - `design-first` → `tidy-first` → `build-incremental` → `code-simplify` → verify → review
- `write-project-wiki` and `write-personal-wiki` preserve durable knowledge discovered along the way.

## Quick start

Install the skills first. The custom agents and AGENTS.md templates are subsequent
setup steps that build on the installed skills.

### 1. Install skills

Install the root `skills/` directory as a native Codex plugin:

```sh
codex plugin marketplace add arumaekawa/codex-skills
codex plugin add codex-skills@codex-skills
```

Start a new Codex task after installation. The plugin is the only installation
route for skills; the repository scripts do not write to `~/.agents/skills`.

### 2. Install custom agents

Clone the repository and install the custom agent definitions:

```sh
git clone https://github.com/arumaekawa/codex-skills.git
cd codex-skills
./scripts/install.sh agents --link --backup
```

### 3. Install AGENTS.md templates

From the same checkout, deploy the global and project templates:

```sh
./scripts/install.sh templates --link --backup
```

### Personal wiki access

`write-personal-wiki` writes to `~/agent-wiki/wiki`, which is normally outside
the active project workspace. Create the directory before using the skill:

```sh
mkdir -p ~/agent-wiki/wiki
```

When Codex uses the `workspace-write` sandbox, add the directory's absolute path
to the user-level `~/.codex/config.toml`:

```toml
[sandbox_workspace_write]
writable_roots = ["/absolute/path/to/agent-wiki/wiki"]
```

Replace the example with the actual absolute path. If the table or
`writable_roots` array already exists, add the path to the existing configuration
instead of replacing other settings. Start a new Codex task after changing the
configuration. See the [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference#configtoml)
for details.

## Skills

These skills plan and carry out development work alongside repository instructions and tests.

### Workflow

| Skill | Description | Use when |
|---|---|---|
| [task-brief](skills/task-brief/SKILL.md) | Clarifies the Goal, Context, Constraints, and Done when, then obtains user confirmation before planning or implementation. | Before complex implementation, significant refactoring, behavior changes, multi-file changes, or ExecPlan creation. |
| [plan-driven-development](skills/plan-driven-development/SKILL.md) | Manages and executes long-running work through a living ExecPlan organized into phases and bounded tasks. | When one Goal requires multiple dependent tasks or work spans phases or sessions. |
| [implementation-workflow](skills/implementation-workflow/SKILL.md) | Executes one bounded code implementation unit from design through independent review in collaboration with subagents, using a living Implementation Note as the shared source of truth. | For every bounded code implementation task except an explicitly specified, self-evident minimal edit. |
| [subagent-supervision](skills/subagent-supervision/SKILL.md) | Guides bounded delegation and critical evaluation of subagent reports. | Whenever work is delegated to one or more subagents. |

### Code Design

| Skill | Description | Use when |
|---|---|---|
| [design-first](skills/design-first/SKILL.md) | Derives the behavior to change and preserve, code scope, implementation approach, and verification from repository evidence. | Before changing code, unless a concrete and unambiguous implementation design is already provided. |

### Implementation

| Skill | Description | Use when |
|---|---|---|
| [tidy-first](skills/tidy-first/SKILL.md) | Applies only the behavior-preserving structural tidies needed to make the designed change safer and clearer. This skill is inspired by Kent Beck's *Tidy First?*. | When a concrete design exists and the current structure obstructs the upcoming behavior change. |
| [build-incremental](skills/build-incremental/SKILL.md) | Implements the designed behavior incrementally in practical, verifiable behavior slices. | After a concrete implementation design is complete and behavior implementation begins. |
| [code-simplify](skills/code-simplify/SKILL.md) | Removes unnecessary helpers, adapters, fallbacks, scaffolding, and excessive abstraction from the current change. | After implementation and before completion, while preserving the intended behavior. |

### Documentation

| Skill | Description | Use when |
|---|---|---|
| [write-project-wiki](skills/write-project-wiki/SKILL.md) | Records durable project-specific knowledge discovered during work in the project wiki. | When specifications, architecture, APIs, data formats, project workflows, or project gotchas should be preserved. |
| [write-personal-wiki](skills/write-personal-wiki/SKILL.md) | Evaluates discovered knowledge and records findings that are reusable across projects in the personal wiki. | When general technical knowledge, workflows, gotchas, external research, or non-sensitive internal R&D knowledge may be reusable. |

### Typical workflow

Break down requested tasks and turn them into a workflow.

```text
User request
├─ Explicitly specified, self-evident minimal code edit → Execute directly
│
├─ Single bounded task
│  ├─ Code task → `implementation-workflow`
│  └─ Non-code task → Execute directly
│
└─ Complex / long-running task
   └─ `task-brief` → User confirmation
      └─ `plan-driven-development` → ExecPlan
         └─ Phase: A verifiable milestone
           └─ Task: Single bounded task
              ├─ Code task → `implementation-workflow`
              └─ Non-code task → Execute directly
```

Each bounded code task follows this collaborative workflow with subagents.
The main agent delegates tasks to [code-implementer](agents/code-implementer.toml) and [code-reviewer](agents/code-reviewer.toml) while supervising their work.

```text
`implementation-workflow`
├─ Main agent
│  └─ Define task → create Implementation Note
├─ `code-implementer`
│  ├─ Design → `design-first`
│  ├─ Tidy → `tidy-first`
│  ├─ Implement → `build-incremental`
│  ├─ Simplify → `code-simplify`
│  └─ Verify
└─ `code-reviewer`
   └─ Review & resolution cycle
```

## Usage

### Local components

After the skills plugin is installed, the repository installer manages two local
components:

```text
agents/*.toml                → $CODEX_HOME/agents/*.toml
templates/AGENTS_global.md   → $CODEX_HOME/AGENTS.md
templates/AGENTS_project.md  → $CODEX_HOME/templates/AGENTS.md
```

`CODEX_HOME` defaults to `~/.codex`. Link mode is recommended for a persistent
checkout and is the default. Install agents and templates in separate steps;
each component can use link or copy mode independently. Copy mode is useful in a
disposable environment or container:

```sh
./scripts/install.sh agents --link
./scripts/install.sh templates --link
./scripts/install.sh agents --copy
./scripts/install.sh templates --copy
```

Existing targets are refused by default. To preserve them under
`$CODEX_HOME/backups/` and continue, use:

```sh
./scripts/install.sh agents --link --backup
./scripts/install.sh templates --link --backup
```

If installation fails, files created by that attempt are removed and backed-up
originals are restored before the command exits.

### Update

Update the skills through the Git marketplace snapshot and reinstall the plugin:

```sh
codex plugin marketplace upgrade codex-skills
codex plugin add codex-skills@codex-skills
```

Update every recorded local component from the same checkout:

```sh
./scripts/update.sh
```

This runs `git pull --ff-only`, validates the checkout, and verifies or refreshes
all recorded local components. Use `./scripts/update.sh --no-pull` after updating
the checkout separately. If a release adds or removes a managed file, uninstall
and reinstall that component.

### Project initialization

```sh
./scripts/init-project.sh /path/to/project
```

This copies `templates/AGENTS_project.md` to the project's `AGENTS.md`. It never
overwrites an existing file.

### Verification

```sh
./scripts/verify.sh
./scripts/verify.sh --installed
./scripts/verify.sh --installed agents
./scripts/verify.sh --installed templates
```

The first command validates the repository structure, selected skill set, plugin
metadata, shell syntax, and basic secret/path hygiene. The second also confirms
that managed installed files have not been replaced or modified. Python 3 is
required for JSON validation; Git is required by the default update flow.

### Uninstall

```sh
./scripts/uninstall.sh --check
./scripts/uninstall.sh agents --check
./scripts/uninstall.sh templates --check
./scripts/uninstall.sh
./scripts/uninstall.sh agents
./scripts/uninstall.sh templates
```

Without a component argument, uninstall checks or removes every recorded local
component. With `agents` or `templates`, it operates only on that component.
Targets are removed only when links still point to this checkout or copies still
match the installer's snapshot. Backups are never removed automatically. Remove
the skills separately through the Codex plugin manager.

## Feedback

Feedback is always welcome! If you have an idea for improvement or run into a
problem, feel free to [open an issue](https://github.com/arumaekawa/codex-skills/issues).
