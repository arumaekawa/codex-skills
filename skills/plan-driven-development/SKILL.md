---
name: plan-driven-development
description: Execute complex, long-running development work through a living ExecPlan organized into phases and bounded tasks. Use when one overall goal requires multiple dependent tasks or must continue across phases or sessions.
---

# Plan-Driven Development

Execute complex development work through a living ExecPlan. Use it to coordinate phases, bounded tasks, progress, and plan revisions.

## When to Use

Use this workflow when one overall goal requires multiple coordinated tasks organized into phases, especially when tasks have dependencies or the work must continue across sessions.

Typical use cases include:

- End-to-end work for a single pull request.
- Initial implementation of an MVP.
- Performance optimization against defined targets.

## Workflow

### 1. Clarify the Task

Inspect relevant repository evidence and identify major dependencies, risks, and sequencing constraints.

Use `$task-brief` as needed to clarify the overall goal, context, constraints, or completion conditions before creating the ExecPlan.

### 2. Define the ExecPlan

Develop an ExecPlan of the work.

Decompose the ExecPlan into appropriately sized **Phases** and **Tasks**.

- A **Phase** is a milestone with a clear goal that is meaningful for the user to review.
- A **Task** is an implementation or work unit for the agent, including the tests or verification appropriate to that unit.

Keep each **Phase** and **Task** cohesive and appropriately scoped.

After drafting the ExecPlan, review its granularity and dependencies, and revise it as needed.

Example: add support for a new model to an inference server.

- Phase 1: Validate inference with an existing model
  - Task 1.1: Verify the inference server with an existing model.
  - Check: Existing-model inference passes validation.
- Phase 2: Implement inference for the new model
  - Task 2.1: Add the new model implementation and run an end-to-end forward test.
  - Task 2.2: Add the startup path for the new model.
  - Task 2.3: Run smoke tests and verify inference behavior.
  - Check: New-model inference passes validation.
- Phase 3: Meet the throughput requirements
  - Task 3.1: Iterate on inference optimization and benchmarking.
  - Check: The result meets the requirements: RTF: XX and P90 latency < Y ms.
- Phase 4: Ship the pull request
  - Task 4.1: Refactor the changes and complete an independent review.
  - Task 4.2: Push the branch and open the pull request.
  - Check: The pull request has been created.

Create the ExecPlan using the instructions and template below.

Present the completed ExecPlan to the user and wait for confirmation before starting execution.

### 3. Execute the Plan

After the user confirms the ExecPlan, set `Status` to `active` and work through its phases and tasks in order.

Keep `Current` and `Last updated` current. Perform the appropriate verification for each task, and record material decisions or discoveries in the ExecPlan.

After completing all tasks and checks in a phase, present the result and supporting evidence to the user. Wait for confirmation before proceeding.

Keep the ExecPlan current at every meaningful stopping point so work can continue from it in a later session.

### 4. Revise the Plan

Treat the ExecPlan as a living plan rather than a fixed specification.

Add or adjust phases and tasks in response to discoveries during the work or requests from the user.

When a decision or discovery changes later work:

- Record it under `Decisions and Discoveries`.
- Revise affected dependencies and checks.
- Update `Current` and `Last updated`.

Keep only information that affects coordination or subsequent work. Do not duplicate details already captured in task-specific records or artifacts.

If the work becomes materially blocked, set `Status` to `blocked` and record the blocker and required next action.

### 5. Complete the Work

After all phases are complete:

1. Confirm that the overall goal and completion conditions are satisfied.
2. Record the outcome, supporting evidence, and remaining issues under `Result`.
3. Set `Status` to `complete`, `Current` to `Complete`, and update `Last updated`.

Do not mark the ExecPlan complete while required tasks or phase checks remain unresolved.

## ExecPlan

Create the ExecPlan at:

`.agent-work/plans/{YYYY-MM-DD}-{short-task-name}.md`

If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`. Do not modify the repository root `.gitignore`.

Use this template:

```markdown
# {Plan title}

Status: draft
Current: Draft
Last updated: {YYYY-MM-DD}

## Goal

{State the overall goal and completion conditions confirmed with the user.}

## Context and Constraints

{Record the context, material constraints, dependencies, and explicit non-goals needed to execute the plan.}

## Phases

### Phase 1: {Phase title}

**Goal and Scope**
- {State what this phase achieves, what it includes, and what it intentionally excludes.}

**Tasks**
- [ ] Task 1.1: {Bounded task}
- [ ] Task 1.2: {Bounded task}

**Checks**
- [ ] Check 1: {Condition that confirms the phase is complete.}

### Phase 2: {Phase title}

**Goal and Scope**
- {State what this phase achieves, what it includes, and what it intentionally excludes.}

**Tasks**
- [ ] Task 2.1: {Bounded task}
- [ ] Task 2.2: {Bounded task}

**Checks**
- [ ] Check 1: {Condition that confirms the phase is complete.}

## Decisions and Discoveries

- {Record only decisions or discoveries that change subsequent work.}

## Result

{At completion, summarize the outcome, supporting evidence, and remaining issues.}
```
