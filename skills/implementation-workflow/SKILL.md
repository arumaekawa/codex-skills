---
name: implementation-workflow
description: Execute non-trivial code implementation tasks through a collaborative workflow with subagents, using a living Implementation Note as the shared source of truth. Use when a change involves design decisions, meaningful regression risk, multiple interacting parts, or work that benefits from delegated implementation and independent review.
---

# Implementation Workflow

Work with subagents on one cohesive implementation unit at a time, using a living Implementation Note as the shared source of truth. Take each unit through task definition, design, implementation, verification, independent review, and documentation.

## When to Use

Use this workflow for a cohesive code implementation task when it involves one or more of:

- non-obvious design decisions
- multiple interacting components or behaviors
- meaningful regression or integration risk
- enough work that delegated implementation and independent review improve reliability

When an ExecPlan exists, apply this workflow within each relevant code implementation task rather than replacing the ExecPlan.

## Working with Subagents

Delegate hands-on implementation and review work to subagents. Main agent supervises and coordinates the task, evaluates results, and decides the next action and whether the task is complete. This workflow does not depend on a separate orchestration skill.

**Always use subagents unless the user explicitly prohibits their use.**

### Agent Roles

- Main agent: Define the task, coordinate assignments, inspect results, evaluate findings, and accept completion.
- `code-implementer`: Perform the design, implementation, simplification, and verification while maintaining the implementation note.
- `code-reviewer`: Independently review the change, record findings, verify their resolutions, and report when no unresolved findings remain.

### Parallelism Policy

- Prefer the same `code-implementer` throughout a coherent implementation task.
- Parallelize review only across non-overlapping scopes, with one lead `code-reviewer` responsible for consolidating findings and reporting the final review status.

## Workflow

Use the Implementation Note defined below as the shared source of truth throughout this workflow.

Apply each "Update the Implementation Note" instruction when the step changes state. Do not defer updates until the end.

### 1. Initialize the Implementation Task

Main agent performs substeps 1.1 and 1.2 sequentially. Complete step 1 only after both substeps are complete.

#### 1.1 Define the Task

Define the task goal, in-scope behavior, explicit non-goals, and known constraints before creating the implementation note or delegating implementation work.

#### 1.2 Create and Initialize the Implementation Note

Create `.agent-work/implementation/{YYYY-MM-DD}-{short-task-name}.md` with a descriptive kebab-case task name using the template below.

If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`. Do not modify the repository root `.gitignore`.

Update the Implementation Note: Task Definition and Progress.

### 2. Implement the Change

The `code-implementer` performs substeps 2.1 through 2.6 sequentially. Complete step 2 only after every substep is complete.

#### 2.1 Design the Implementation

Follow `$design-first` to inspect repository evidence and finalize a concrete design covering Behavior, Code Scope, optional Flow, Verification, and material Assumptions and Open Questions. Do not proceed while a question that materially affects implementation remains unresolved.

Update the Implementation Note: Progress and Design.

#### 2.2 Tidy the Existing Implementation if Needed

Use the accepted design to decide whether `$tidy-first` is needed. Apply only small, behavior-preserving tidies that make the change safer or clearer, and verify preserved behavior when practical.

Update the Implementation Note: Progress and Implementation Record > Decisions and Discoveries, Changes, and Verification Results.

#### 2.3 Implement the Behavior

Use `$build-incremental` to implement practical behavior slices, verifying each useful surface and comparing it with the accepted design. If the design becomes incomplete, too broad, or incorrect, pause and revise it before continuing.

Update the Implementation Note: Progress, Design, and Implementation Record > Decisions and Discoveries, Changes, and Verification Results.

#### 2.4 Reassess the Implementation

Review the complete implementation against the goal, scope, preserved behavior, accepted design, and any newly discovered problems, constraints, missing cases, or out-of-scope changes. Return to the appropriate earlier substep when material revision is needed.

Update the Implementation Note: Progress, Design, and Implementation Record > Decisions and Discoveries.

#### 2.5 Simplify the Change

Use `$code-simplify` to remove unnecessary or redundant implementation while preserving intended behavior exactly.

Update the Implementation Note: Progress and Implementation Record > Decisions and Discoveries and Changes.

#### 2.6 Test and Verify

Run verification proportional to risk and scope, covering requested and preserved behavior, relevant failure paths, affected integration points, and broader checks when warranted. Do not complete the step while relevant verification is failing or unperformed without a documented reason.

If verification fails, determine whether it was caused by the current change and return to the earliest affected substep. Keep step 2 incomplete until all relevant failures are resolved and verification is rerun.

Update the Implementation Note: Progress, Design, and Implementation Record > Decisions and Discoveries and Verification Results.

### 3. Review the Implementation

Have an independent `code-reviewer` review the implementation for correctness, regressions, design alignment, unnecessary complexity, missing verification, and undocumented behavior changes.

Use the following review cycle:

1. `code-reviewer` reviews the implementation and records findings.
2. Main agent evaluates the findings and decides the required action.
3. `code-implementer` addresses accepted findings.
4. `code-reviewer` verifies the resolutions and re-reviews the resulting implementation for remaining or newly introduced issues.

Repeat until the `code-reviewer` reports no unresolved findings. Main agent then decides whether to accept the implementation or reopen an earlier step. Keep step 3 incomplete until Main agent accepts the implementation.

Update the Implementation Note: Progress, Review, and Implementation Record > Changes and Verification Results.

### 4. Update Documentation if Needed

Main agent determines whether the completed change requires documentation updates.

Update relevant user, developer, API, architecture, workflow, or wiki documentation when needed.

Update the Implementation Note: Progress and Documentation.

### 5. Confirm Completion

Main agent confirms that:

- steps 1 through 4 are complete and the Implementation Note reflects the final state
- the implementation matches the final Task Definition and Design
- verification supports the requested and preserved behavior and relevant failure paths
- the `code-reviewer` reports no unresolved findings

If any condition is unmet, reopen the earliest affected step. Otherwise, mark the task and Implementation Note as complete.

Update the Implementation Note: Status and Progress.

## Implementation Note

Maintain one living implementation note for each implementation task. Use it as the shared source of truth for design, implementation, verification, review, and documentation.

Read and update the note throughout the workflow. Record decisions, discoveries, deviations, and results when they become relevant. Keep it concise; do not store raw logs or a transcript of the work.

Keep the Design section current. When a decision or discovery changes the design, update the Design section and record the reason under Implementation Record > Decisions and Discoveries.

Use this template:

```markdown
# Implementation: {Task}

- Status: In progress
- Started: {YYYY-MM-DD}

## Task Definition

Maintained by: Main agent

### Goal

{Describe the intended outcome.}

### Scope

#### In scope

- {Required change}

#### Non-goals

- {Behavior or area intentionally excluded}

### Constraints

- {Known technical, product, repository, or operational constraint}

## Progress

- [ ] 1. Main agent – Initialize the Implementation Task
  - [ ] 1.1 Define the Task
  - [ ] 1.2 Create and Initialize the Implementation Note
- [ ] 2. `code-implementer` – Implement the Change
  - [ ] 2.1 Design the Implementation
  - [ ] 2.2 Tidy the Existing Implementation if Needed
  - [ ] 2.3 Implement the Behavior
  - [ ] 2.4 Reassess the Implementation
  - [ ] 2.5 Simplify the Change
  - [ ] 2.6 Test and Verify
- [ ] 3. `code-reviewer` – Review the Implementation
- [ ] 4. Main agent – Update Documentation if Needed
- [ ] 5. Main agent – Confirm Completion

## Design

Maintained by: `code-implementer`

### Behavior

- Change: {Behavior to add or modify}
- Preserve: {Existing behavior that must remain unchanged}

### Code Scope

- Files and symbols: {Files, modules, classes, and functions to change or add}
- Interfaces and dependencies: {Material interfaces and dependencies}
- Implementation: {Concrete implementation design; include high-level pseudocode only when it clarifies a non-obvious design}

### Flow

{Include a short flow only when branching or data movement would otherwise be unclear. Omit this section when it is unnecessary.}

### Verification

- {How changed behavior will be demonstrated}
- {How preserved behavior and failure paths will be checked}

### Assumptions and Open Questions

- {Include only unresolved items that materially affect implementation. Omit this section when there are none.}

## Implementation Record

Maintained by: `code-implementer`

### Decisions and Discoveries

- {Decision, discovery, or design revision and its impact}

### Changes

- {Concise summary of implemented changes}

### Verification Results

- {Command or check}: {Result}

## Review

Maintained by: Main agent

- Finding: {Review finding}
  Resolution: {Change made, reason no change was needed, or accepted risk}
- Review status: {Findings remain or no unresolved findings}
- Main agent decision: {Accept the implementation or reopen an earlier step}

## Documentation

Maintained by: Main agent and `code-implementer`

- {Updated documentation or reason no update was needed}
```
