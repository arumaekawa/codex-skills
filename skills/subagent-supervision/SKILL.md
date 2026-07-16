---
name: subagent-supervision
description: Supervise delegated work by giving subagents bounded, outcome-focused instructions and critically evaluating their reports before acting. Use whenever work is delegated to one or more subagents.
---

# Subagent Supervision

Delegate bounded work to subagents while retaining responsibility for decisions and completion.

## How To Instruct Subagents

Keep each assignment bounded and outcome-focused. Include only the items that affect the work:

- Goal: The concrete outcome to produce.
- Success criteria: What must be true for the assignment to be complete.
- Scope: What is included and excluded.
- Context and evidence: The information and artifacts needed to perform the work.
- Constraints and authority: Applicable rules, allowed actions, and approval boundaries.
- Expected output: The artifact to produce and the required report.
- Stop and blocker conditions: When to stop, ask for help, or report a blocker.

Describe the desired outcome without prescribing unnecessary steps. State each instruction once and omit unrelated context.

For independent evaluation, provide source artifacts and evaluation criteria without revealing the intended conclusion or another agent's findings.

Parallelize only independent assignments. Keep dependent work sequential.

## How Subagents Should Report

Require a concise report containing:

- Outcome: What was completed, partially completed, or blocked.
- Evidence and artifacts: The sources, files, changes, or other evidence supporting the result.
- Verification: The checks performed and their results.
- Deviations and remaining issues: Scope changes, blockers, unresolved questions, or material risks.

Include the evidence needed to evaluate the result, but omit raw logs and unnecessary process narration.

## How To Evaluate Subagent Results

- Treat the report as evidence, not authority. Compare it with the goal, scope, constraints, and success criteria.
- Look for unsupported claims, missing evidence, scope deviations, unresolved assumptions, and inconsistencies.
- Use the report to target further checks. Inspect artifacts or rerun verification only where a claim is material or uncertain; do not repeat the entire task or every check by default.
- Use focused follow-ups when the report is incomplete, ambiguous, unsupported, or conflicting.
- Main agent decides the next action and whether the work is complete.
