---
name: project-planning
description: House conventions for planning a project: meta/backlog.md (Claude's work, most important first), meta/history.md (each session's decisions), the user's actions in their todo app, the hub project that plans across projects, sub-projects, project briefs, and plans that state the current position. Use when creating or updating backlog.md or history.md, leaving an action for the user, starting or moving a sub-project, writing a brief or a plan, or when asked what to work on next.
---

# Project planning

How a project records what to do and what was decided. Work is split by who can finish it. Work Claude could finish alone once the user says "go" is Claude's and goes in the project's `backlog.md`. Work that needs the user (to phone, decide, attend, sign, buy or be somewhere) is the user's and goes in their todo app.

The user's own instructions name the todo app, the skill that drives it, and the hub project. If they name none, ask before writing anything outside the project.

## The `meta/` folder

`backlog.md` and `history.md` are Claude's files, so they live in the project's `meta/` folder, which leaves the top level to the user's own files and the project's instructions. Wherever this skill names them, it means the ones in `meta/`.

A project that still has them in its root keeps using them there until its own session moves them: read and write `meta/backlog.md` where it exists, and otherwise the one in the root, so a project never has two. To move them, use `git mv`, then fix the links the move breaks: relative links inside the two files, links to them from other files, and the project's instructions. Record the move in `history.md`.

## backlog.md

Lists Claude's work, most important first. Each item is a section headed by a short, specific title, not a number: the title is how the item is referred to, so reordering never breaks a reference. Give an item a date only where one really applies. Where the detail is in another file, point at it rather than repeating it.

Take an item off when it is done or dropped, and say which in `history.md`.

Claude's recurring work goes in a **Recurring** section at the end of the file, below the one-off items, since it does not belong in the user's todo app. Each recurring item is headed by its title like any other, and says how often it recurs and when it is next due ("Monthly, on the first working day. Next due: 1 December."). When one is done, move its next due date on and say in `history.md` that it was done; the item itself stays.

## history.md

Records each session's decisions, since the todo app keeps no history of edits. Entries are short and dated, newest first, one per session or decision: what changed and why (an item done, dropped, added or re-dated), leaving out what git already shows. Only the project's own sessions write it, except for the entry another project's session adds when it does work there that the user asked for now (see Other projects).

## The todo app

- The project has a project in the todo app for the user's actions in it, whose notes start with a line naming the folder: `Folder: ~/path/to/project`. The hub project finds projects through this line.
- Before a session ends, add each action it leaves for the user to the todo app's inbox, without asking, and say so: an action mentioned only in the session gets lost. Its notes name the project it came from, so the hub project can file it without asking.
- An action that cannot wait is set to Today, or the app's equivalent, as it is added, and the session says so, since a todo app may have no priority to mark it urgent.
- A date goes in as a deadline on a todo. The todo app holds the plan, and the hub project's Done calendar, unless the user's instructions give it another name, holds what the user actually did, which only the hub project writes: at each review it adds an event for each piece of work, at the time it was done. Any project, the hub included, may write to the user's personal calendar, which their instructions name, when the user asks or when it proposes an event and the user agrees. Other calendars are written only as the user's instructions allow. Other calendar work goes to the hub project as an item in its `backlog.md`; if it cannot wait, the session tells the user to open a hub session.
- Add or change items without asking only when the user has just asked for that change. Propose anything else (sorting the inbox, moving, dating, completing, cancelling or deleting items) and do it once the user agrees.
- Cancel a loop that is closed but not done, rather than deleting it, so the app keeps a record of it. Deleting is for mistakes such as duplicates.
- A todo's time is when its work was planned, not when it was done, so a session never moves a todo to show when it was worked on. A session cannot tell when the user has stopped work on a todo, so at a stopping point it offers to add a new comment on it saying what was done, when and for how long, and what is left if it is not finished, and adds it once the user agrees. It leaves the description and earlier comments as they are, since a todo app may keep no earlier versions of an edited comment, and leaves the todo where it is for the hub project to rebook.

## The hub project

The hub project holds the user's loops that belong to no project and plans their week from every project (including the next due dates in each backlog's Recurring section), the todo app and the calendar. It passes work to a project by adding an item to that project's `backlog.md`, without committing. At session start a hook asks for any uncommitted `backlog.md` change to be committed: commit `backlog.md` on its own, with a `history.md` entry noting which items came from the hub project.

`/project-planning:join-hub` brings a project into the hub.

## Other projects

Work a session finds for another project, the hub project included, goes in that project's `backlog.md` and names the project it came from, unless the user asks for it to be done now. When they do, read that repository's `AGENTS.md` or `CLAUDE.md` before changing anything and follow it, since it is not loaded into the session, and add no backlog item for the work. Add an entry to that project's `history.md` saying what changed and which project's session made the change.

## Rules for every project

A rule or preference meant for every project, wherever it comes up, is an item in the `backlog.md` of the project holding the user's global configuration, which their instructions name. Word it with the user in that session. Do not pass it through the hub project, and do not keep it in the project's own files or memory.

## No memories

Do not save memories. A fact about a project goes in that project's files, and a preference for every project goes to the global configuration project, as Rules for every project says. A project that still holds memories sorts them at its next session, with the user's agreement: facts move into its files, preferences go to the global configuration project as proposals, and anything recorded elsewhere or out of date is deleted.

## Where projects live

The user's instructions may name a folder where projects live. Taking over a project means moving its folder there; a code repository with a remote stays where it is.

## Commits

A project's repository is Claude's to commit: commit after each agreed change, with the trailer the user's instructions give, unless the project's instructions say otherwise.

## Public repositories

A public repository keeps no `backlog.md` or `history.md`, since they name the user's projects and directories. Its planning lives in the private project that owns it, and its work is done from a session there with the public repository as a second working directory.

## Sub-projects

A sub-project is a piece of a project's work with a brief of its own, planned by the project that holds it:

- It lives in a folder of its own in the parent's `projects/` folder. The folder holds its `brief.md`, an `AGENTS.md` where it needs guidance of its own, and its repository in `repo/` once it has code.
- A brief that carries its own plan keeps it there as a checklist with estimated hours and no schedule, which the hub project books. Ticks record progress, with the actual time beside each, and decisions about the plan go in the parent's `history.md`. A sub-project has no `backlog.md`, `history.md` or project in the todo app of its own.
- What it learns that would still be worth finding once it is done, such as notes from study, goes to the user's knowledgebase, where their instructions name one. Its plan and records, such as a practice log, stay in its folder, and its decisions in the parent's `history.md`.
- One that outgrows its parent, such as one that other projects come to depend on, moves out into a project of its own, which may hold sub-projects in turn. Its entries in the parent's `history.md` are copied into the new project's `history.md`, since the parent may later be renamed or removed, and the parent's `history.md` records that it moved out and where to. Links to it are updated.
- `repo/` is ignored by the parent's git and stays there once it has a remote. Everything in it must be fit to publish, so the brief and anything else private stay outside it. Check each file before its first commit there, since removing it later means rewriting the repository's history. Who commits in `repo/`, and what Claude writes there, is for the parent's or the sub-project's instructions to say. Without them, it is Claude's to commit.
- One that is dropped rather than finished is deleted, since git history keeps its brief.

## Project briefs

A project undertaken for a reason outside itself has a brief recording why it exists, what it supports, the domain model, the invariants to test, and the design decisions to make deliberately. Read the brief before working on the project. A sub-project's brief stays in its folder, beside `repo/`. When a project moves into a repository of its own, its brief moves with it (`docs/brief.md`) and the old location keeps a pointer to it, unless the repository is public or may become public: then the brief stays in the private project that owns it, as its planning does.

## Plans carry no history

Plans, briefs and `backlog.md` state the current position: the commitment, the scope and the dates still ahead. When one changes, overwrite the old value and put the reason in `history.md` or the commit message; never record the change in the file ("raised from 1 hour on 20 October", "re-cut on 18 October").

`history.md` and other records that are history by nature (logs, meeting notes, correspondence) are unaffected.

## Formatting

Planning files are not hard-wrapped: one line per paragraph, so a diff shows only what changed.

## Nothing in the background

Recurring work is done in a session: Claude's is an item in the Recurring section of `backlog.md`, and the user's is a repeating todo in the todo app or part of the hub project's reviews. Do not set up cron jobs, scheduled agents, cloud routines or self-pacing loops for it. A session-start hook is acceptable, since it runs only when the user opens a session.
