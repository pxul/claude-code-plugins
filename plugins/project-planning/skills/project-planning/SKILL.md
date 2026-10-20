---
name: project-planning
description: House conventions for planning a project — next-steps.md (what to work on by when, reviewed daily), project briefs, and plans that state the current position with history left to git. Use when creating or updating next-steps.md, a project brief or a plan, or when asked what to work on next.
---

# Project planning

How a project records what to do next and why. The daily review of `next-steps.md` is the `morning-review` skill.

## next-steps.md

Lives at the project root and lists what to work on by when. It opens with the review line, which the session-start hook reads, so keep its format exact:

```
Reviewed 20 October 2026 (Tuesday).
```

Then the sections, in this order:

- **Today** and **Tomorrow**, with the day and date in the heading (`## Today (Tuesday 20 October)`).
- **Carried over**: anything planned for a day that has passed and was not done, with the date it was first due and the days carried (`Settlement period types (due 20 Oct, carried 2 days)`). At each review the user decides whether each item gets a new day or is dropped. When nothing is carried, the section stays with a line saying so.
- **This week** (the calendar week, to Sunday), **Next week** and **Later**, each item placed by the day it is due or should be done.
- **Waiting on**: one line per thing owed by someone else, naming the heading its follow-up is under. No tasks, no detail.
- **Ongoing**: the standing work and its pace. No tasks.

Follow-ups on things waiting on someone else, and steps in ongoing work, go under the heading for the day they are next acted on.

Where the project has a time commitment, a line under the review line states it (hours a weekday, hours a weekend day), **Ongoing** gives its split between blocks of work, and **Today** and **Tomorrow** give each block a goal sized to its hours. Say which hours are minimums; on a crowded day the other blocks shrink rather than the day overrunning.

Items point at the files holding the detail rather than repeating it, as Markdown links relative to the root (`[docs/brief.md](docs/brief.md)`), not paths in backticks. Link to a file, never a folder: editors such as Obsidian cannot open a folder from a link.

Update the file whenever an item is done or a change alters what comes next, not only at the review.

## Project briefs

A project undertaken for a reason outside itself has a brief recording why it exists, what it supports, the domain model, the invariants to test, and the design decisions to make deliberately. Read the brief before working on the project. When a project moves into its own repository, its brief moves with it (`docs/brief.md`) and the old location keeps a pointer to it.

## Plans carry no history

Plans, briefs and `next-steps.md` state the current position: the commitment, the scope and the dates still ahead. When one changes, overwrite the old value and put the reason in the commit message; never record the change in the file ("raised from 1 hour on 20 October", "re-cut on 18 October"). Git is the history.

Records that are history by nature (logs, meeting notes, correspondence, a progress log) are unaffected.

## Formatting

Planning files are not hard-wrapped: one line per paragraph, so a diff shows only what changed.

## Nothing in the background

Recurring work (a weekly check, a follow-up) goes in `next-steps.md` under the day it is due and is done in a session. Do not set up cron jobs, scheduled agents, cloud routines or self-pacing loops for it. A session-start hook is acceptable, since it runs only when the user opens a session.
