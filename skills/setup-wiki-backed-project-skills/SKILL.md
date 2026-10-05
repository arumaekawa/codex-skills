---
name: setup-wiki-backed-project-skills
description: Set up a repository-local skill for creating project skills whose canonical procedures live in docs/wiki.
---

# Set Up Wiki-backed Project Skills

Install the bundled wiki workflow and repository-local routing skill.

## Applicability

Read the repository's AGENTS.md and documentation conventions.

Proceed when `docs/wiki` is already used as the project wiki or AGENTS.md
explicitly prescribes that convention. Create the necessary directories
if the convention is prescribed but they do not exist yet.

If repository instructions conflict with this convention or its adoption
is unclear, explain the issue and stop without changing the documentation
structure.

## Install

1. Check for an equivalent workflow or skill. Update existing equivalents
   instead of creating duplicates, preserving project-specific customizations.
2. Install the bundled templates:
   - `assets/wiki-backed-project-skills.md` →
     `docs/wiki/workflows/wiki-backed-project-skills.md`
   - `assets/create-wiki-backed-project-skill.md` →
     `.agents/skills/create-wiki-backed-project-skill/SKILL.md`
3. Follow repository naming and skill placement conventions, adjusting
   relative links as needed.
4. Add the workflow to the wiki index, creating the index if needed.

## Verify

- The repository skill's relative link resolves to the wiki workflow.
- The wiki contains the full procedure; the skill provides discovery and routing.
- Run the skill validator when available and `git diff --check`.
