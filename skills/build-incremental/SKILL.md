---
name: build-incremental
description: Use during implementation after a concrete design exists to build in practical behavior slices, keeping each step aligned with the design while avoiding overly tiny steps, unused scaffolding, unnecessary helpers, adapters, fallbacks, compatibility layers, and broad input handling.
---

# Build Incremental

Use this skill during implementation to build the designed behavior in practical steps. Prefer coherent behavior slices over file-based or mechanically tiny steps.

## Workflow

1. Read the concrete implementation design provided by the caller.
2. Choose the next practical behavior slice.
3. Implement only that slice while following the implementation guardrails.
4. Confirm the step still matches the design and implementation guardrails.
5. Run the smallest useful verification when practical.
6. If the design becomes incomplete or incorrect, revise it or return it for revision before continuing.
7. Record or return the changes, verification results, and material discoveries as directed by the caller.
8. Repeat until the designed behavior is implemented.

## Step Size

A step should be a coherent behavior slice that is small enough to review and verify, but not so small that it fragments readable implementation.

Good boundaries include:

- one normal behavior path
- one failure path
- one integration point
- one local, behavior-preserving structure change that prepares the next behavior slice

## Implementation Guardrails

While implementing each step:

- Prefer clear, readable implementation over clever, overly generic, or compact code.
- Add concise comments where they clarify non-obvious intent, constraints, or reasoning; avoid comments that merely restate the code.
- Do not route around existing code with exception paths, side helpers, adapters, or compatibility layers; improve the local structure when needed.
- Do not split logic into tiny functions before responsibilities become clear.
- Do not add fallback behavior the user did not request.
- Use clear errors for unsupported or unexpected states instead of guessing or silently continuing.
- Do not add unused scaffolding or broaden input handling beyond the design.
