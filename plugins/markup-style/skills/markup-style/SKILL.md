---
name: markup-style
description: House markup conventions for any prose — documentation, README sections, commit messages, pull/merge request descriptions, issue bodies, code comments. Wrap code identifiers, and repository/module/package names, in backticks (including possessive form). Use whenever writing or reviewing prose that names code or repositories.
---

# Markup style

House markup conventions for prose — documentation, commit messages, pull/merge request descriptions, issue bodies, code comments, README sections. Complements the lean and plain rules in `lean-prose`.

## Backtick code identifiers

- Wrap code identifiers in backticks: type, function, method, field, package, and variable names (`RecordingClock`, `IntN`, `slog`).
- **Repository, module, and package names are identifiers too** — always backtick them (`http-client`, `order-service`, `config`, `cli`, `docgen`), including in possessive form (`http-client`'s tests). A repository name is not a proper noun; it stays in backticks wherever it appears.
- A descriptive phrase is not an identifier: "the order service" (spaced prose) stays plain, whereas the repository `order-service` (the hyphenated token) is backticked.

## Cross-document links

- Link to another document with markdown link text, never a bare backticked filename. For ADRs, the link text is the hyphenated `ADR-NNN` form: `[ADR-001](001-event-sourced-orders.md)`.
- Same-repository references use relative markdown links.
- Cross-repository references use absolute URLs to the file on its hosting service (e.g. `https://github.com/<owner>/<repo>/blob/main/<path>`), never relative paths into sibling checkouts — those break for anyone without the same checkout layout.

## Lists

- An inline enumeration of four or more items, or of structurally parallel items, becomes a bulleted list. A short two- or three-item aside stays inline.