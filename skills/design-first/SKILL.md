---
name: design-first
description: Produce a concrete implementation design from repository evidence before changing code. Use before making any code change unless a concrete and unambiguous implementation design is provided.
---

# Design First

Inspect the existing implementation and produce a concrete design before changing the code.
Do not implement the change while using this skill.

## Workflow

1. Read the code and other repository evidence relevant to the requested change.
2. Identify the behavior to change and the behavior to preserve.
3. Define the concrete code scope and implementation design.
4. Review the design against the requested behavior, existing contracts, and
   design principles. Simplify or revise it before finalizing.
5. Define how the changed and preserved behavior will be verified.
6. Record or return the design as directed by the caller.

## Design Principles

- Design the change to fit the existing implementation. Prefer direct local structural improvement over side paths, adapters, or compatibility layers.
- Identify any small behavior-preserving tidy that should precede implementation, and keep it distinct from the behavior change.
- Start with cohesive implementation units; extract functions or classes only when the responsibility is worth naming.
- Do not add fallback behavior, broad input handling, or unused flexibility that the request does not require.
- Use clear errors for unsupported or unexpected states instead of guessing or silently continuing.

## Design Information

The design should include:

1. Behavior
   - What should change.
   - What should be preserved.
2. Code Scope
   - The file paths, classes, functions, and modules to change or add.
   - Material interfaces and dependencies.
   - High-level pseudocode only when it helps clarify a non-obvious design.
3. Flow
   - Include a short flow only when branching or data movement would otherwise be unclear.
4. Verification
   - Define verification that demonstrates both changed and preserved behavior.
5. Assumptions and Open Questions
   - Include only unresolved items that materially affect implementation.
