---
name: project-planning
description: House conventions for planning a project: backlog.md (Claude's work, most important first), history.md (each session's decisions), the user's actions in their to-do app, the hub project that plans across projects, project briefs, and plans that state the current position. Use when creating or updating backlog.md or history.md, leaving an action for the user, writing a brief or a plan, or when asked what to work on next.
---

# Project planning

How a project records what to do and what was decided. Work is split by who can finish it. Work Claude could finish alone once the user says "go" is Claude's and goes in the project's `backlog.md`. Work that needs the user (to phone, decide, attend, sign, buy or be somewhere) is the user's and goes in their to-do app.

The user's own instructions name the to-do app, the skill that drives it, and the hub project. If they name none, ask before writing anything outside the project.

## backlog.md

Lives at the project root and lists Claude's work, most important first. Each item is a section headed by a short, specific title, not a number: the title is how the item is referred to, so reordering never breaks a reference. Give an item a date only where one really applies. Where the detail is in another file, point at it rather than repeating it.

Take an item off when it is done or dropped, and say which in `history.md`.

Claude's recurring work goes in a **Recurring** section at the end of the file, below the one-off items, since it does not belong in the user's to-do app. Each recurring item is headed by its title like any other, and says how often it recurs and when it is next due ("Weekly, on Mondays. Next due: Monday 2 November."). When one is done, move its next due date on and say in `history.md` that it was done; the item itself stays.

## history.md

Lives at the project root and records each session's decisions, since the to-do app keeps no history of edits. Entries are short and dated, newest first, one per session or decision: what changed and why (an item done, dropped, added or re-dated), leaving out what git already shows. Only the project's own sessions write it.

## The to-do app

- The project has a project in the to-do app for the user's actions in it, whose notes start with a line naming the folder: `Folder: ~/path/to/project`. The hub project finds projects through this line.
- Before a session ends, add each action it leaves for the user to the to-do app's inbox, without asking, and say so: an action mentioned only in the session gets lost.
- A date goes in as a deadline on a to-do. Only the hub project writes to calendars.
- Add or change items without asking only when the user has just asked for that change. Propose anything else (sorting the inbox, moving, dating, completing, cancelling or deleting items) and do it once the user agrees.
- Cancel a loop that is closed but not done, rather than deleting it, so the app keeps a record of it. Deleting is for mistakes such as duplicates.

## The hub project

The hub project holds the user's loops that belong to no project and plans their week from every project (including the next due dates in each backlog's Recurring section), the to-do app and the calendar. It passes work to a project by adding an item to that project's `backlog.md`, without committing. At session start a hook asks for any uncommitted `backlog.md` change to be committed: commit `backlog.md` on its own, with a `history.md` entry noting which items came from the hub project.

`/project-planning:join-hub` brings a project into the hub.

## Public repositories

A public repository keeps no `backlog.md` or `history.md`, since they name the user's projects and directories. Its planning lives in the private project that owns it, and its work is done from a session there with the public repository as a second working directory.

## Project briefs

A project undertaken for a reason outside itself has a brief recording why it exists, what it supports, the domain model, the invariants to test, and the design decisions to make deliberately. Read the brief before working on the project. When a project moves into its own repository, its brief moves with it (`docs/brief.md`) and the old location keeps a pointer to it.

## Plans carry no history

Plans, briefs and `backlog.md` state the current position: the commitment, the scope and the dates still ahead. When one changes, overwrite the old value and put the reason in `history.md` or the commit message; never record the change in the file ("raised from 1 hour on 20 October", "re-cut on 18 October").

`history.md` and other records that are history by nature (logs, meeting notes, correspondence) are unaffected.

## Formatting

Planning files are not hard-wrapped: one line per paragraph, so a diff shows only what changed.

## Nothing in the background

Recurring work is done in a session: Claude's is an item in the Recurring section of `backlog.md`, and the user's is a repeating to-do in the to-do app or part of the hub project's reviews. Do not set up cron jobs, scheduled agents, cloud routines or self-pacing loops for it. A session-start hook is acceptable, since it runs only when the user opens a session.
