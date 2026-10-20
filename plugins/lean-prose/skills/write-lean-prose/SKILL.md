---
name: write-lean-prose
description: House style for any prose — documentation, README sections, commit messages, pull/merge request descriptions, issue bodies, code comments. Makes text lean (every sentence earns its place) and plainly worded (no words outside general use). Use whenever writing prose, and when asked to tighten, shorten, or simplify existing text.
---

# Write lean prose

Two goals: **lean** (no padding) and **plain** (no uncommon words). Apply both to any prose — documentation, commit messages, pull/merge request descriptions, issue bodies, code comments, README sections — whether writing it fresh or tightening existing text.

## Lean

- Say each thing once. If a point appears in two places, keep it where the reader needs it and cut the other.
- Attach a reason to its rule as a clause ("specs are deleted when the contract goes — git history is the archive"), not as a follow-on sentence that restates the rule first.
- Cut warm-up sentences that restate the heading, qualifiers that change nothing ("quite", "fairly", "really"), and closers that summarise what was just said.
- A section earns its place by adding information. Drop headings kept only to complete a template.
- Lean is not telegram style. Keep complete sentences; shorten by cutting points that carry no weight, not by clipping grammar.

## Plain

- Prefer the everyday word when it carries the same meaning:

  | Instead of | Write |
  |---|---|
  | utilise | use |
  | prior to | before |
  | subsequently | then |
  | in order to | to |
  | leverage, facilitate | use, help |
  | commence, terminate | start, end |
  | endeavour | try |
  | aforementioned | that, this |

  The table is guidance, not a complete list: the test is whether you would say the word to a colleague.
- Keep technical terms of art (idempotent, Superseded, monorepo) even when uncommon. Precision beats plainness when they conflict.
- If the plain word loses meaning the original carried, keep the original. Never trade accuracy for simplicity.

## Unpublished work

Describe unpublished work as the current design, directly. Do not frame it as a change from a previous version — no "rather than a separate field", "reverses the earlier position", "previously X". Unpublished work has no prior art for the reader to contrast against, so the framing only wastes attention.

- Exception: ADRs legitimately record decision history and supersessions.

## Blacklist

These phrases are banned outright — never use them, in fresh text or when editing. Rephrase around them by naming the concrete thing they gesture at.

| Never use | Instead |
|---|---|
| seam, seams | interface, boundary, or injection point |
| fidelity gain | name the concrete benefit, e.g. "tests exercise the real code path" |
| contract surface, integration artifact | name the concrete thing: "interface" (API sense), "contract" (agreement sense), or rephrase plainly |
| hermetic | say what you mean: "self-contained", "isolated", "no external dependencies" |
| load-bearing | say what depends on it, e.g. "X reads this comment, so it must stay" |
| the honest X | name X directly: "the boundary", "the interface" |
| shape of the X | describe the actual structure, e.g. "the design", "the layout" |
| test shape, the shape the X reaches | say what the setup does and why, e.g. "the link is wrapped in a `<span>`, because a bare `<a>` among prose is exempt" |

## Editing someone else's text

Fix length and vocabulary only.

- Do not change meaning or drop content. If a cut would lose information, keep the text or ask.
- Do not rewrite the author's voice: their punctuation habits, sentence rhythm, and structure stay. A long sentence that carries weight is not a fault.

## Before finishing

- Read the text back. Any sentence that can go without losing information goes.
- Any word you would not say aloud to a colleague gets replaced or justified as a term of art.
- For an edit: confirm the meaning is unchanged from the original.