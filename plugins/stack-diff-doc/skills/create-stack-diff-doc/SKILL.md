---
name: create-stack-diff-doc
description: Create a stack-diff planning doc (issue-<slug>.md in the repo root) for a single change in a stacked-diff workflow. Produces a branch slug, an issue title and body (Scope and Out of scope always; Background and Tests only when they add information), and a git-spice-ready proposed commit message. Use when the user asks for a "change doc", "stack diff doc", "issue doc", or wants to document or plan one diff in a stack before committing.
---

# Create a stack-diff planning doc

This skill writes a single planning document for **one diff in a stacked-diff workflow**. Each doc captures what one self-contained change does, in a form that feeds the workflow's tooling:

- The **commit message** is the unit of integration: git-spice uses the commit subject as the pull/merge request title and the body as its description. So the doc embeds a ready-to-use commit message rather than leaving it implicit.
- The **issue title/body** are copied by hand into the repository's host (GitHub or GitLab) to create the tracking issue.
- The **branch slug** names the git-spice branch for the diff.

The skill **writes the doc and stops.** It never creates branches, issues, or commits, and never runs git — it proposes; the developer executes.

Write **lean and clinical**, in the house prose style defined by the `lean-prose` plugin (`/lean-prose:write-lean-prose`) — that skill is the canonical reference for lean, plainly worded prose across this plugin set. State what the diff does in plain, factual sentences; do not pad. "Keeping it lean" below applies the style to this doc's sections.

## When to use

Reach for this once a piece of work is understood well enough to be its own diff — typically after planning the change in conversation, or when there is a spec, PRD, or generated task list to draw on. One doc describes one diff; a stack of N diffs is N docs.

## Gathering the content

Synthesise the doc from the context already available, in roughly this order of preference:

1. The **planning conversation** — what the developer and you have just worked out.
2. Project **specifications** (e.g. `docs/specifications/`), a **PRD**, or steps generated from one.
3. The **working diff** — `git diff` / `git status` for what has actually changed, when the work is already done.

Only ask the developer targeted questions for **genuine gaps** — do not invent scope, rationale, or boundaries to fill a template. The most common gaps worth asking about:

- The change's **title** and a one-line statement of what it does and why.
- Where it sits in the stack (what it builds on, what follows it).
- The **Out of scope** boundary — what a reviewer might expect to be included but is deliberately deferred to another diff.
- The **issue number** this diff relates to, and whether the diff completes that issue (`Closes`) or only advances it (`Part of`).

## Producing the doc

1. Derive a **kebab-case slug** from the title (e.g. "Rename the Store interface to Repository" → `rename-store-to-repository`). Keep it short and descriptive.
2. Confirm the slug and the target filename `issue-<slug>.md` with the developer before writing.
3. Write the file to the **repository root** as `issue-<slug>.md`, following the template below.
4. After writing, briefly summarise what you produced and list the **manual next steps** (see below). Do not perform them.

## Document template

Follow this structure, filling each section with concrete, specific content — the lead and Scope are always present; Scope and Out of scope are tight bullet lists. **Background** and **Tests** are optional: include them only when they add information (see "Keeping it lean"), and drop the heading entirely when they do not. (The template is shown in a four-backtick fence so the inner commit-message block keeps its normal triple backticks.)

````markdown
# Stack Diff: <Title>

## Branch slug

`<slug>`

(Slug only — no issue-number prefix. The issue is linked from the commit body, not the branch name.)

## Issue title

<One-line issue title — what the change does, in imperative or noun form.>

## Issue body

<Lead paragraph: what the diff does, plainly. Note where it sits in the stack and the spec/PRD it relates to, if any, and if it is a pure refactor / no behavioural change.>

### Background  *(optional — omit unless it adds context not in the lead)*

<Why this change exists and the context a reviewer needs: the problem, the decision and its rationale, and any alternatives considered and rejected.>

### Scope

- <Concrete, file- or component-level bullets of what the diff changes.>

### Tests  *(optional — omit for docs-only / pure-refactor diffs where the lead already says "no behavioural change")*

<What testing covers the change.>

### Out of scope

- <What a reviewer might expect here but is deliberately deferred, and to where (e.g. a later diff on the stack).>

## Proposed commit message

Used by git-spice as the pull/merge request title (subject) and description (body).

```
<Subject line — concise, imperative, ~50 chars.>

<Body — wrapped prose explaining what changed and why. This becomes the PR/MR
description.>

Closes #<NN>
```
````

### Keeping it lean

The doc should be as short as the change allows — a reviewer skims it, so every line must carry weight. General prose style is `lean-prose`'s job; these rules are what it means for this doc's sections.

- **Omit inapplicable sections.** Drop Background when the lead already says why; drop Tests for docs-only or pure-refactor diffs once the lead notes "no behavioural change". Do not keep a heading just to fill the template.
- **No restating across sections.** If the lead or Scope already covers a point, do not repeat it in the commit body or another section.
- **Lean commit body.** Two or three sentences of prose, then the issue reference. Summarise the change at a level above the Scope bullets — do not re-list the changed files or enumerate each ADR's contents.

### Rules for the doc

- **Issue reference, no author trailer.** End the commit body with an issue reference on its own line: `Closes #<NN>` when this diff completes the issue, or `Part of #<NN>` when it only advances it (so the issue is not auto-closed early). Do not append `Co-Authored-By` or other trailers. GitHub and GitLab both close a `Closes #<NN>` issue automatically when the change merges to the default branch.
- **Subject and body are real.** The subject must stand alone as a PR/MR title; the body must read as a PR/MR description.
- These planning docs are **not specifications** — sequencing, stack position, and process detail belong here (unlike a `docs/specifications/` file, which stays purely technical).

## After writing

Summarise the doc and present the manual next steps for the developer to perform, for example:

1. Create the issue from the **Issue title/body**, and note its number for the `Closes` / `Part of` reference.
2. Create the git-spice branch using the slug (no issue-number prefix).
3. Commit the change using the **Proposed commit message** so git-spice picks up the PR/MR title and description, and the host links and (for `Closes`) closes the referenced issue when the change merges to the default branch.

Leave all of these to the developer; the skill's job ends at the written doc.