---
name: create-work-item-briefs
description: Write the two higher-altitude descriptions of a whole piece of work — an epic brief (brief technical) and a business brief (for a product tracker such as Jira) — as markdown files. Use when asked for an "epic description/brief", a "business brief", or a "high-level description" of a piece of work, or when a piece of work has been split into stack-diffs and its epic and tracker entries need writing or updating.
---

# Create work-item briefs

A piece of work is described at three altitudes. This skill writes the top two as markdown files; the [create-stack-diff-doc](../../../stack-diff-doc/skills/create-stack-diff-doc/SKILL.md) skill writes the bottom one.

| Altitude | Artefact | Audience | Says |
|---|---|---|---|
| Highest | **Business brief** | Product, stakeholders | What the work delivers and why it matters. No code. |
| Middle | **Epic brief** | Engineers orienting to the work | What the work is and how it fits together, technically but briefly. |
| Lowest | **Stack-diff docs** (one per diff) | Reviewer of one PR/MR | What one self-contained change does. Handled by `create-stack-diff-doc`. |

The skill **writes the two briefs and stops.** It never edits the repository host or the product tracker, and never runs git — it produces the files; the developer pastes them in.

Always emit both as markdown files, never as chat-only text: the developer keeps them beside the work and pastes from them.

## What each brief is

- **Epic brief** — a brief technical description of the whole piece of work: the approach, the moving parts and how they interact, where the work lives, and phasing. It orients an engineer; it is not a specification and does not restate spec detail (no method-by-method wiring, per-type behaviour, or test plans). For cross-repository work, name the hub overview as the source of truth and point at it.
- **Business brief** — the same work one altitude higher, for a non-technical reader: the outcome, why it matters, and the phasing at a glance. No code identifiers, no repository names, no wire formats.

## Gathering the content

Synthesise from what is already available, in order of preference: the planning conversation; the hub overview and specifications; the stack-diff docs already written for the work. Only ask the developer for genuine gaps — do not invent scope or rationale to fill a template.

## Producing the docs

1. Derive a **kebab-case slug** for the work (e.g. "Order export" → `order-export`).
2. Write two files to the repository root — for cross-repository work, the hub repository (the one holding the overview):
   - `epic-<slug>.md`
   - `business-<slug>.md`
3. Confirm the slug and filenames with the developer before writing.
4. Write both in [lean-prose](../../../lean-prose/skills/write-lean-prose/SKILL.md) style.
5. After writing, summarise and list the manual next steps. Do not perform them.

## Templates

### `epic-<slug>.md`

```markdown
# <Work title>

<Lead: what the work delivers and the shape of the approach, in a few
sentences. Note any shared terminology the reader needs.>

## How it works

- <The moving parts and how they interact — enough to orient, not to
  implement.>

## Where the work lives

<For cross-repository work: name the hub overview as the source of truth and
its path; list the participating repositories. For single-repository work:
name the spec.>

## Phasing

1. <Phase — one line. Mark which phase this work is.>
```

Drop **Where the work lives** for single-repository work if the lead already names the one spec. Drop **Phasing** if the work is not phased.

### `business-<slug>.md`

```markdown
<Lead: the outcome, in one plain sentence.>

<What it enables, as a short bullet list of concrete benefits.>

<One sentence on the approach that matters to a non-engineer — e.g. a cost or
risk it addresses.>

<One sentence on phasing, if phased: what this phase covers versus later ones.>
```

## Keeping it lean

- The epic brief is a description, not a task list. Keep the stack-diffs out of its body — they are the epic's child issues (sub-issues on GitHub), not prose.
- Say each thing once across the two briefs. The business brief is not a summary of the epic brief; it is the same work for a different reader.
- Drop any template section that would only restate another.

## After writing

Summarise the two briefs and present the manual next steps, for example:

1. Replace the epic description with `epic-<slug>.md` — a GitLab epic, or a parent issue on GitHub (convert repo-relative paths to full URLs, since the epic lives outside the repo).
2. Set the product tracker item's description (e.g. a Jira epic or story) from `business-<slug>.md`.
3. Link the work's stack-diff issues as children of the epic (sub-issues on GitHub).

Leave all of these to the developer; the skill's job ends at the two written files.
