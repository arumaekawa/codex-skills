---
name: plan-driven-development
description: Execute complex, long-running development work through a living ExecPlan organized into phases and bounded tasks. Use when one overall goal requires multiple dependent tasks or must continue across phases or sessions.
---

# Plan-Driven Development

Execute complex development work through a living ExecPlan. Use it to coordinate phases, bounded tasks, progress, and plan revisions.

## When to Use

Use this workflow when one overall goal requires multiple coordinated tasks organized into phases, especially when tasks have dependencies or the work must continue across sessions.

For one bounded task, use `$implementation-workflow` when it changes code; otherwise, execute it directly.

## Workflow

### 1. Initialize the Work

Use `$task-brief` to confirm the overall goal, context, constraints, and completion conditions with the user before creating the ExecPlan.

Inspect relevant repository evidence and identify major dependencies, risks, and sequencing constraints.

If the work does not require multiple coordinated tasks, use `$implementation-workflow` directly instead.

### 2. Define the ExecPlan

Break the work into outcome-oriented phases and bounded, verifiable tasks. Order the work by dependency, address major uncertainty early, and parallelize only independent, non-overlapping tasks. Keep each code implementation task small enough for one use of `$implementation-workflow`.

Tasks may include any bounded work required by the phase, not only code changes.

Example: fine-tune and evaluate a model.

- Phase 1: Establish the data and baseline
  - Task 1: Implement dataset loading and validation.
  - Task 2: Implement and run the baseline evaluation.
  - Check: A reproducible smoke run produces baseline metrics.
- Phase 2: Implement the training change
  - Task 1: Implement the model and training changes.
  - Task 2: Add training, checkpoint, and evaluation configuration.
  - Check: A smoke training run produces a loadable checkpoint.
- Phase 3: Run and evaluate the experiment
  - Task 1: Run the planned training and evaluation.
  - Task 2: Compare the result with the baseline.
  - Check: The result and supporting artifacts satisfy the defined evaluation criteria.

Create the ExecPlan at:

`.agent-work/plans/{YYYY-MM-DD}-{short-task-name}.md`

If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`. Do not modify the repository root `.gitignore`.

Initialize the ExecPlan using the template below.

### 3. Execute the Plan

Work through the phases and tasks in plan order unless dependencies or new evidence require revision.

Before starting a task:

- Update `Current` and `Last updated`.
- Confirm that the task still supports the phase's Goal and Scope.

For each task:

- If the task changes code, apply `$implementation-workflow` and keep its details in the Implementation Note.
- For other tasks, perform the appropriate work and retain relevant evidence.
- Mark the task complete only after its intended outcome has been verified.

Complete a phase only after all its tasks and checks are complete.

Keep the ExecPlan current at every meaningful stopping point so work can continue from it in a later session.

### 4. Revise the Plan

Treat the ExecPlan as a living plan rather than a fixed specification.

When a decision or discovery changes later work:

- Record it under `Decisions and Discoveries`.
- Revise affected phases, tasks, dependencies, and checks.
- Update `Current` and `Last updated`.

Keep only information that affects coordination or subsequent work. Do not duplicate details already captured in task-specific records or artifacts.

If the work becomes materially blocked, set `Status` to `blocked` and record the blocker and required next action.

### 5. Complete the Work

After all phases are complete:

1. Perform the checks under `Final Validation`.
2. Confirm that the overall goal and completion conditions are satisfied.
3. Record the outcome, supporting evidence, and remaining issues under `Result`.
4. Set `Status` to `complete`, `Current` to `Complete`, and update `Last updated`.

Do not mark the ExecPlan complete while required tasks, phase checks, or final validation remain unresolved.

## ExecPlan

Use this template:

```markdown
# {Plan title}

Status: active
Current: Phase 1 / Task 1
Last updated: {YYYY-MM-DD}

## Goal

{State the overall goal and completion conditions confirmed in the Task Brief.}

## Context and Constraints

{Record the context, material constraints, dependencies, and explicit non-goals needed to execute the plan.}

## Phases

### Phase 1: {Phase title}

**Goal and Scope**
- {State what this phase achieves, what it includes, and what it intentionally excludes.}

**Tasks**
- [ ] Task 1: {Bounded task}
- [ ] Task 2: {Bounded task}

**Checks**
- [ ] {Condition that confirms the phase is complete.}

### Phase 2: {Phase title}

**Goal and Scope**
- {State what this phase achieves, what it includes, and what it intentionally excludes.}

**Tasks**
- [ ] Task 1: {Bounded task}
- [ ] Task 2: {Bounded task}

**Checks**
- [ ] {Condition that confirms the phase is complete.}

## Decisions and Discoveries

- {Record only decisions or discoveries that change subsequent work.}

## Final Validation

- {Describe how to confirm that the overall goal and completion conditions are satisfied.}

## Result

{At completion, summarize the outcome, supporting evidence, and remaining issues.}
```
