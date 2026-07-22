---
name: test-driven-debug
description: Debug and fix bugs with a regression-test Red-Green cycle and a living Debug Note. Use for unintended code behavior, including bugs found during code review or testing.
---

# Test Driven Debug

Trace a bug to its cause, prove it with a failing regression test, fix the cause, and verify the test turns green.

## When to Use

Use this skill to fix:

- bugs found during code review
- regressions or failing tests caused by unintended behavior
- behavior that violates an existing expectation or contract

Do not use it for new features or intentional behavior changes.

Create `.agent-work/debug/{YYYY-MM-DD}-{short-task-name}.md` from the template below. If creating `.agent-work/`, create `.agent-work/.gitignore` containing only `*`; do not modify the repository root `.gitignore`. Update the matching section and progress after each step; keep evidence and decisions, not raw logs.

## Workflow

1. **Define the issue.** Record the observed and expected behavior, reproduction conditions, scope, and constraints. Separate facts from assumptions.
2. **Identify the cause.** Reproduce the issue through the smallest reliable path when practical, trace the real code path, and validate where behavior diverges. Do not fix without evidence for both the failure and its cause.
3. **Establish Red.** Add or identify a regression test for the expected behavior, using a public behavior path when practical. Add focused preservation tests only for uncovered behavior the fix could break. Before the fix, confirm the regression test fails for the intended reason and any preservation tests pass.
4. **Fix the cause.** Apply the smallest clear correction without weakening the tests or adding unrequested fallback behavior. Return to the earliest affected step if new evidence invalidates the cause or test.
5. **Establish Green.** Run the regression test and any preservation tests selected in step 3. Set the Debug Note status to Complete only when the cause is supported, the regression test changed from Red to Green for the intended reason, and any preservation tests pass.

## Debug Note

```markdown
# Debug: {Task}

- Status: In progress
- Started: {YYYY-MM-DD}

## Issue

- Observed: {Incorrect behavior}
- Expected: {Correct behavior}
- Reproduction: {Conditions or command}
- Scope and constraints: {Boundaries and known constraints}

## Progress

- [ ] 1. Define the Issue
- [ ] 2. Identify the Cause
- [ ] 3. Establish Red
- [ ] 4. Fix the Cause
- [ ] 5. Establish Green

## Investigation

- Evidence: {Confirmed facts and relevant code path}
- Cause: {Supported causal explanation}

## Tests

- Regression: {Test name or location}
- Red: {Command, observed failure, and why it proves the bug}
- Preservation: {At-risk behavior, focused tests, and pre-fix results, or `None`}

## Fix

- Change: {Correction to the identified cause}

## Verification

- Green: {Regression test command and passing result}
- Preservation: {Post-fix results, or `None`}
```
