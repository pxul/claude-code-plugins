---
name: doc-conventions
description: House structural conventions for documentation — ADR title and status format, working-note Lifespan lines, Mermaid diagram file and render conventions, the specification/implementation-notes document set for a piece of work, API contract conventions (OpenAPI/AsyncAPI as spec artifacts, snake_case wire naming), and adopting the destination repository's style when relocating a document. Use when writing or editing ADRs, working notes, specifications, or OpenAPI/AsyncAPI contracts, adding a diagram to a document, or moving a document between repositories.
---

# Document conventions

House conventions for the structure of documents. Prose style, markup and spelling are in the house rules (`house-rules`).

## ADRs

- Title is `# NNN — Sentence case description`: the number, a space, an em dash, a space, then a sentence-case description. No `ADR-` prefix, no colon.
- The number matches the `NNN-kebab-case.md` filename.
- Status is a plain line, `Status: Accepted` — not bold `**Status:**`.
- No horizontal-rule (`---`) separators anywhere in the body.
- Acronyms stay capitalised in titles (`HTTP`, `HTTPServer`).

## Working notes

A working note carries a `**Lifespan**:` line under its title stating the condition under which it should be deleted. A note with no stated end condition outlives its usefulness.

## Diagrams

Each diagram is a standalone Mermaid `.mmd` file rendered to a PNG committed beside it, embedded with `<img>` — never an inline mermaid block. A host's inline renderer may apply its own default layout and ignore the ELK layout directive (GitLab does); committing the PNG is what pins the layout every reader sees.

- Flowcharts and state diagrams use the ELK layout (sequence diagrams have their own engine and take no layout directive):

  ```
  ---
  config:
    layout: elk
  ---
  ```

- Render every diagram in a document at the same scale, `mmdc -i <name>.mmd -o <name>.png -s 3`, and embed each at its natural width — the rendered PNG's pixel width divided by the scale:

  ```
  mmdc -i lifecycle.mmd -o lifecycle.png -s 3   # 1734px wide
  <img src="../lifecycle.png" width="578">      # 1734 / 3
  ```

  Displaying at 1/scale of the pixel width means every image carries the same 3× pixels per displayed pixel, so all render equally crisp regardless of how large or small the diagram is, with headroom for HiDPI screens and zoom. Picking display widths any other way leaves some diagrams soft and others bloated.

- Re-render the PNG whenever the `.mmd` changes.

## Documentation workflow

A piece of work is described by:

- **Specification** — `docs/specifications/<name>.md`. Technical design and contract only; the source for all behavioural implementation.
- **ADRs** — `docs/adr/`, per the conventions above, recording the hard-to-reverse decisions behind the specification.
- **Implementation notes** — `docs/<name>-implementation-notes.md`. A working note holding what the specification must not: work items beyond behaviour (migrations, spikes, tooling), the testing strategy, and out-of-scope guardrails. Deleted when the work ships — first promoting any out-of-scope decision that must stay rejected to an ADR.

Developers cut their own issues from the specification plus the implementation notes; agents do not generate issues unless explicitly asked. No PRD: business-altitude descriptions are `work-item-briefs`' job.

## API contracts

A specification's REST and event-stream contracts are formalised as OpenAPI (REST) and AsyncAPI (WebSocket) files under `docs/specifications`, written as part of the specification drop — they are contract, not deferred implementation work. The markdown specification points to them.

Wire conventions:

- snake_case for everything on the wire: JSON field names, message type discriminators, and enum values. Spec-internal identifiers that never appear on the wire — OpenAPI/AsyncAPI schema and message component names — keep the format's idiomatic PascalCase.
- Event-stream message names are imperative for the commands a client sends (`start`, `place_order`) and past-tense facts for the events a server emits (`started`, `order_placed`, `order_rejected`). Avoid `.success`-style suffixes; a single generic `error` message carries failures.

## Relocating a document

- When moving a document into another repository, adopt the destination repository's house style; do not carry the source repository's formatting across (title case, bold status, horizontal rules).
- Leave a redirect stub only for a document already committed and published. Do not leave one for a document not yet committed — there is nothing published to redirect from.