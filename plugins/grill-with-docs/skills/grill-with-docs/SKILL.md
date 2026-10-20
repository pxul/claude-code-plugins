---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, producing the specification, ADRs, glossary entries, and implementation notes as we go.
disable-model-invocation: true
---

Run a `/grilling` session, using the `/domain-modeling` skill.

The session does not produce a PRD or issues. ADRs and glossary (`CONTEXT.md`) entries are recorded as decisions crystallise during the session, per the house `doc-conventions`. When the frontier is empty and understanding is confirmed, produce:

- **Specification** — `docs/specifications/<name>.md`: technical design and contract only; no process, sequencing, or testing strategy.
- **Implementation notes** — `docs/<name>-implementation-notes.md`: a working note (with a Lifespan line) holding what the specification must not — work items beyond behaviour, the testing strategy, and out-of-scope guardrails.

Before writing the specification, sketch the boundary at which the feature will be tested — existing boundaries preferred, the highest possible, the fewer the better — and check it matches the user's expectations.

Developers cut their own issues from the specification plus the implementation notes.