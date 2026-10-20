---
name: to-issues
description: Break a specification (plus its implementation notes) into end-to-end vertical-slice issues, each declaring its blocking edges, published to GitHub, GitLab, or local markdown files.
disable-model-invocation: true
---

# To Issues

Break a specification into **issues** — vertical slices, each declaring the issues that **block** it. Each slice is a *tracer bullet*: a narrow but complete path through every layer, proving the whole route works end-to-end; later slices thicken it.

## Process

### 1. Gather context

Read the specification in `docs/specifications` (the user normally passes its path) and its companion implementation-notes working note in `docs/` — the notes carry the work items the specification must not (migrations, spikes, tooling), the testing strategy, and the out-of-scope guardrails. Issues come from both.

Where issues live: if the repo's `origin` remote is GitHub and `gh` is authenticated for it, use GitHub issues; if it is GitLab and `glab` is authenticated for it, use GitLab issues; otherwise use local markdown files as described in step 5. The user can override any of these.

### 2. Explore the codebase

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary (`CONTEXT.md`), and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each issue its **blocking edges** — the other issues that must complete before it can start. An issue with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a single slice; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own issue blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in an issue blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify issue — green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each issue, show:

- **Title**: short descriptive name
- **Blocked by**: which other issues (if any) must complete first
- **What it delivers**: the end-to-end behaviour this issue makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each issue only depend on issues that genuinely gate it?
- Should any issues be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the issues

The issues are the same wherever they live; only the shape of the blocking edges changes:

- **GitHub** → publish one issue per slice with `gh issue create`, in dependency order (blockers first) so blocking edges can reference real issue numbers. Use GitHub's native "blocked by" issue dependency where `gh` can set it (directly or through `gh api`); otherwise rely on the template's **Blocked by** section. No labels.
- **GitLab** → publish one issue per slice with `glab`, in dependency order (blockers first) so blocking edges can reference real issue numbers. Use GitLab's native blocking relationship. No labels.
- **Local files** → write one file per issue under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order. Each file's "Blocked by" lists the numbers/titles it depends on; comments append under a `## Comments` heading. Use the per-issue template below — one issue per file, never a single combined file.

Work the **frontier**: any issue whose blockers are all done. For a purely linear chain that means top to bottom.

<local-issue-template>

# <NN> — <Issue title>

**What to build:** the end-to-end behaviour this issue makes work, from the user's perspective — not a layer-by-layer implementation list.

**Blocked by:** the numbers/titles of the issues that gate this one, or "None — can start immediately".

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-issue-template>

<hosted-issue-template>

## What to build

The end-to-end behaviour this issue makes work, from the user's perspective — not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking issue, or "None — can start immediately".

</hosted-issue-template>

In any form, reference the specification section each issue implements, and avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.