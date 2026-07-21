---
name: implementation-workflow
description: Implement cohesive, non-trivial features and behavior changes through design, implementation, verification, and independent review, using a living Implementation Note. Use when the work involves non-obvious design, multiple interacting components or behaviors, meaningful regression or integration risk, or benefits from a structured workflow and independent review.
---

# Implementation Workflow

Carry one cohesive feature or behavior change from task definition through design, implementation, verification, independent review, and documentation. Perform the implementation directly to retain end-to-end context, and use a living Implementation Note to track the work.

## When to Use

Use this workflow for a cohesive feature implementation or behavior change when it involves one or more of:

- non-obvious design decisions
- multiple interacting components or behaviors
- meaningful regression or integration risk
- enough work that a structured workflow and independent review improve reliability

When an ExecPlan exists, apply this workflow within each relevant feature or behavior-change task rather than replacing the ExecPlan.

## Workflow

Maintain the Implementation Note defined below as a concise living record throughout this workflow.

Apply each "Update the Implementation Note" instruction when the step changes state. Do not defer updates until the end.

### 1. Initialize the Implementation Task

Complete substeps 1.1 and 1.2 sequentially. Complete step 1 only after both substeps are complete.

#### 1.1 Define the Task

Define the task goal, in-scope behavior, explicit non-goals, and known constraints before creating the Implementation Note or beginning implementation.

#### 1.2 Create and Initialize the Implementation Note

Create `.agent-work/implementation/{YYYY-MM-DD}-{short-task-name}.md` with a descriptive kebab-case task name using the template below.

If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`. Do not modify the repository root `.gitignore`.

Update the Implementation Note: Task Definition and Progress.

### 2. Implement the Change

Perform substeps 2.1 through 2.6 directly and sequentially. Do not delegate design or implementation work. Complete step 2 only after every substep is complete.

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

Delegate an independent review to one `code-reviewer`. Provide the reviewer with the Implementation Note, the relevant changes, and the available verification results.

Use the following review cycle:

1. `code-reviewer` reviews the implementation and reports findings.
2. Evaluate the findings and decide the required action.
3. Address accepted findings, update the Implementation Note, and rerun relevant verification.
4. Ask the same `code-reviewer` to verify the resolutions and review the resulting implementation for remaining or newly introduced issues.

Repeat until the `code-reviewer` reports no unresolved findings. Then decide whether to accept the implementation or reopen an earlier step. Keep step 3 incomplete until the implementation is accepted.

If the user explicitly prohibits subagent use, perform the review directly and record that it was not independent.

Update the Implementation Note: Progress, Review, and Implementation Record > Changes and Verification Results.

### 4. Update Documentation if Needed

Determine whether the completed change requires documentation updates.

Update relevant user, developer, API, architecture, workflow, or wiki documentation when needed.

Update the Implementation Note: Progress and Documentation.

### 5. Confirm Completion

Confirm that:

- steps 1 through 4 are complete and the Implementation Note reflects the final state
- the implementation matches the final Task Definition and Design
- verification supports the requested and preserved behavior and relevant failure paths
- the `code-reviewer` reports no unresolved findings

If any condition is unmet, reopen the earliest affected step. Otherwise, mark the task and Implementation Note as complete.

Update the Implementation Note: Status and Progress.

## Implementation Note

Maintain one living Implementation Note for each implementation task. Use it to keep the task definition, design, progress, implementation record, verification, review, and documentation current.

Record decisions, discoveries, deviations, and results when they become relevant. Keep the note concise; do not store raw logs or a transcript of the work.

Keep the Design section current. When a decision or discovery changes the design, update the Design section and record the reason under Implementation Record > Decisions and Discoveries.

Use this template:

```markdown
# Implementation: {Task}

- Status: In progress
- Started: {YYYY-MM-DD}

## Task Definition

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

- [ ] 1. Initialize the Implementation Task
  - [ ] 1.1 Define the Task
  - [ ] 1.2 Create and Initialize the Implementation Note
- [ ] 2. Implement the Change
  - [ ] 2.1 Design the Implementation
  - [ ] 2.2 Tidy the Existing Implementation if Needed
  - [ ] 2.3 Implement the Behavior
  - [ ] 2.4 Reassess the Implementation
  - [ ] 2.5 Simplify the Change
  - [ ] 2.6 Test and Verify
- [ ] 3. Review the Implementation
- [ ] 4. Update Documentation if Needed
- [ ] 5. Confirm Completion

## Design

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

### Decisions and Discoveries

- {Decision, discovery, or design revision and its impact}

### Changes

- {Concise summary of implemented changes}

### Verification Results

- {Command or check}: {Result}

## Review

- Finding: {Review finding}
  Resolution: {Change made, reason no change was needed, or accepted risk}
- Review status: {Findings remain or no unresolved findings}
- Decision: {Accept the implementation or reopen an earlier step}

## Documentation

- {Updated documentation or reason no update was needed}
```
