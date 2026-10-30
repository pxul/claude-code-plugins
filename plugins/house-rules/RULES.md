# House rules

Style rules for everything written in this session: prose, documentation, commit messages, pull/merge request descriptions, issue bodies, code comments and code identifiers.

## British English

Use British English spelling everywhere: prose, documentation, comments and code identifiers alike.

- Identifiers follow the same rule: `Initialise`, not `Initialize`; `Serialiser`, not `Serializer`.
- Common cases: `-ise`/`-isation` not `-ize`/`-ization` (serialise, initialisation); `-our` not `-or` (colour, behaviour); `-re` not `-er` (centre, metre); `licence` (noun) and `license` (verb); `catalogue`; `cancelled`.
- Exception: match the spelling a third party has already fixed. Standard-library and third-party API names stay as written (`encoding/json`'s `Marshaler`, an `initialize` in a vendored SDK): you implement the name that exists, you do not re-spell it.

## Lean and plain prose

Two goals: **lean** (no padding) and **plain** (no uncommon words), whether writing fresh or tightening existing text.

### Lean

- Say each thing once. If a point appears in two places, keep it where the reader needs it and cut the other.
- Attach a reason to its rule as a clause ("specs are deleted when the contract goes, since git history is the archive"), not as a follow-on sentence that restates the rule first.
- Cut warm-up sentences that restate the heading, qualifiers that change nothing ("quite", "fairly", "really"), and closers that summarise what was just said.
- A section earns its place by adding information. Drop headings kept only to complete a template.
- Lean is not telegram style. Keep complete sentences; shorten by cutting points that carry no weight, not by clipping grammar.

### Plain

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

### Unpublished work

Describe unpublished work as the current design, directly. Do not frame it as a change from a previous version (no "rather than a separate field", "reverses the earlier position", "previously X"): unpublished work has no prior version for the reader to contrast against, so the framing only wastes attention. ADRs are the exception, since they record decision history and supersessions.

### Banned phrases

Never use these, in fresh text or when editing. Rephrase around them by naming the concrete thing they gesture at.

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

### Editing someone else's text

Fix length and vocabulary only.

- Do not change meaning or drop content. If a cut would lose information, keep the text or ask.
- Do not rewrite the author's voice: their punctuation habits, sentence rhythm and structure stay. A long sentence that carries weight is not a fault.

### Before finishing

- Read the text back. Any sentence that can go without losing information goes.
- Any word you would not say aloud to a colleague gets replaced or justified as a term of art.
- For an edit: confirm the meaning is unchanged from the original.

## Markup

### Backtick code identifiers

- Wrap code identifiers in backticks: type, function, method, field, package and variable names (`RecordingClock`, `IntN`, `slog`).
- Repository, module and package names are identifiers too: always backtick them (`http-client`, `order-service`, `config`, `cli`, `docgen`), including in possessive form (`http-client`'s tests). A repository name is not a proper noun; it stays in backticks wherever it appears.
- A descriptive phrase is not an identifier: "the order service" (spaced prose) stays plain, whereas the repository `order-service` (the hyphenated token) is backticked.

### Cross-document links

- Link to another document with Markdown link text, never a bare backticked filename. For ADRs, the link text is the hyphenated `ADR-NNN` form: `[ADR-001](001-event-sourced-orders.md)`.
- Same-repository references use relative Markdown links.
- Cross-repository references use absolute URLs to the file on its hosting service (e.g. `https://github.com/<owner>/<repo>/blob/main/<path>`), never relative paths into sibling checkouts, which break for anyone without the same checkout layout.

### Lists

An inline enumeration of four or more items, or of structurally parallel items, becomes a bulleted list. A short two- or three-item aside stays inline.

## Formatting

- Times use the 24-hour clock: 09:30, 20:00.
- No em dashes. Use a colon, a comma, brackets or a new sentence instead. An en dash in a range (2024–2026) is fine.
- Markdown is not hard-wrapped: one line per paragraph, so a diff shows only what changed.
