---
name: tidy-first
description: Inspect existing code against an accepted implementation design and apply only small, behavior-preserving structural tidies that make the upcoming behavior change safer or clearer. Use before implementing a behavior change in existing code when a concrete design exists.
---

# Tidy First

Inspect the existing implementation against the accepted design before changing behavior. Apply a tidy only when a specific structural obstacle makes the planned change harder to implement, verify, or review.

## Decide Whether to Tidy

- Identify structural obstacles directly relevant to the accepted design.
- Tidy first only when a small, local change will reduce immediate implementation risk or complexity.
- Prefer no tidy when the behavior change can be implemented clearly and safely as-is.
- Treat broad redesigns, public interface changes, migrations, and cross-system refactors as design work rather than tidies.

## Apply the Tidy

1. Identify the smallest behavior-preserving change that removes the obstacle.
2. Apply one focused structural change at a time.
3. Keep the tidy separate and independently reviewable from the upcoming behavior change.
4. Verify preserved behavior with focused checks when practical.
5. Stop when the accepted design can be implemented directly.

## Guardrails

- Do not implement the requested behavior change.
- Do not change observable behavior, interfaces, persisted data, errors, logging semantics, validation, authorization, or compatibility requirements.
- Do not perform unrelated cleanup, speculative abstraction, or broad refactoring.
- Do not continue tidying after the immediate obstacle has been removed.
- If behavior preservation is uncertain, stop and report the uncertainty instead of treating the change as a tidy.

## Report the Result

Record or return the tidy decision, changes, verification results, and material discoveries as directed by the caller:

- Decision: Tidy applied or no tidy needed.
- Changes: The structural changes made.
- Verification: The checks performed and their results.
- Discoveries: Any relevant constraint, risk, or design issue found during the tidy.
