---
name: code-simplify
description: Use after implementation and before completion to simplify the current change by removing unnecessary helpers, tiny function extractions, adapters, compatibility layers, silent fallbacks, broad input handling, unused scaffolding, and workaround paths while preserving the intended behavior exactly.
---

# Code Simplify

Use this skill after implementation to simplify the current change. Focus only on over-engineering introduced by this change; do not perform broad cleanup.

## Principles

- Preserve Behavior Exactly: keep intended behavior unchanged, including errors, outputs, input acceptance, logging, timing assumptions, and public contracts.
- Follow Project Conventions: match existing structure, naming, abstraction level, error handling, and test style.
- Prefer Clarity Over Cleverness: prefer direct readable code over clever compression, generic abstractions, or hard-to-follow shortcuts.
- Scope to What Changed: simplify only code related to the current change; avoid unrelated refactors, formatting churn, or drive-by cleanup.
- Report Behavior or Design Problems: if simplification reveals a behavior or design problem, report it instead of changing behavior as part of simplification.

## Workflow

1. Review the current diff.
2. Read the task requirements and any concrete implementation design provided by the caller.
3. Apply the principles while identifying simplify targets.
4. Simplify only when intended behavior remains unchanged.
5. Run the smallest useful verification when practical.
6. Record or return the simplifications, verification results, and material discoveries as directed by the caller.

## Simplify Targets

Look for:

- helpers or functions that are too small, used once, or hide simple logic
- adapters, wrappers, or compatibility layers not required by the request or existing contract
- fallback behavior the user did not request
- unsupported states that should raise clear errors instead of silently continuing
- input handling broadened beyond the task requirements or design
- unused scaffolding or future-proofing
- side paths added to avoid improving existing code
