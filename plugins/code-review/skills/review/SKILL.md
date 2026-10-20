---
name: review
description: House code review standards — a summary, findings grouped by severity (Critical, Major, Minor, Nitpick) and written to a numbered review file in the project root, with a focus on readability, correctness, safety, tests, types and dead code. Use when the user asks for a code review or a pull/merge request review.
---

# Code review

When the user asks for a code review or a pull/merge request review, follow these instructions rather than any built-in code review command or skill.

## Output

Write findings into a markdown file in the project root named `<branch-name>-review-<NN>-<short-hash>.md`, where `NN` is a zero-padded integer starting at `01`, incremented on each review round. Read any existing review files for this branch first and use them as context.

Do not hard-wrap long lines in the markdown output. Each finding must have its title, `**Location:**`, and `**Problem:**` on separate lines.

## Structure

1. **Summary** — A short summary of the code under review (what changed and why it matters).

2. **Findings by severity** — Categorise every finding as **Critical**, **Major**, **Minor**, or **Nitpick**. Present grouped by severity (Critical first). Number findings `C1, C2…`, `M1, M2…`, `m1, m2…`, `n1, n2…` — resetting the counter per severity level.

   - **Critical** (`CN`): Bugs, security, or broken behaviour that should block merge.
   - **Major** (`MN`): Significant correctness, safety, or maintainability issues; fix before merge.
   - **Minor** (`mN`): Worth fixing soon; small correctness or clarity improvements.
   - **Nitpick** (`nN`): Optional polish; style or consistency only.

## Review focus

- **Readability, correctness, idiomaticity, safety** — Especially potential panics and edge cases (nil derefs, out-of-range, empty collections, invalid inputs).
- **Test quality and coverage** — Tests for new or changed behaviour; edge cases and error paths where they matter; meaningful assertions. **Avoid duplicate logic in tests**: do not re-implement or mirror production logic to compute "expected" values (e.g. a helper that replicates the same algorithm under test). If both are wrong in the same way, the test still passes. Prefer explicit expected values (literals, fixed data) or property/invariant assertions so the test states what should happen without re-implementing how.
- **Types** — Types for all variables appropriate. Watch for mistaken **zero-valued reference types** vs **nil** (or vice versa), e.g. empty slice/map vs nil, JSON `null` vs `[]`, "absent" vs "empty".
- **Dead code after removals** — If code was removed, flag leftover unused functions, constants, types, or other symbols.
- **Second pass** — After the first pass, go through again for anything missed; do not focus on trivial or nitpick-only issues.
- **Line numbers** — Double-check all line numbers referenced. Do not use line numbers from the diff; verify against the source file.

## What to include

Report only **issues** and **notably good choices**. Do not list what is correct or unproblematic unless particularly good or appropriate.

## Agent usage

Do NOT run finder or verifier agents in parallel. Run each agent sequentially: complete one before launching the next. This preserves the intent of the multi-phase pipeline where each phase informs the next.
