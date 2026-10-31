---
name: join-hub
description: Bring a project into the hub project: create its project in the to-do app with a Folder line, split its existing lists between backlog.md and the to-do app, start history.md, and add a section to its instructions. Use when the user asks to join, onboard or add a project to the hub.
disable-model-invocation: true
---

# Join the hub

Brings the current project under the conventions of the `project-planning` skill. Read that skill first. The user's own instructions name the to-do app, the skill that drives it, and the hub project; if they name none, stop and ask.

1. If the project is a public repository, stop: its planning belongs in the private project that owns it.
2. Find the project's existing lists of work, such as `next-steps.md`, a `TODO` file or a to-do section in its instructions, and its existing records of decisions or progress, such as a progress log or dated notes in a plan.
3. Propose the split: each open item either goes in `backlog.md`, if Claude could finish it alone once the user says "go", or to the to-do app, if it needs the user. Claude's recurring items go in the backlog's Recurring section, each with how often it recurs and when it is next due. Show the user the whole split and the order of the backlog, and change nothing until they agree.
4. Create the project in the to-do app, its notes starting with `Folder: <project path>`, using `~` for the home folder. Ask the user where in the app it goes, such as an area, and add the user's items to it.
5. Write `backlog.md`.
6. Start `history.md`. If the old lists or records hold history worth keeping, summarise it in dated entries first; then add an entry, dated today and above them as the newest, saying the project joined the hub and where its lists went.
7. Remove the old lists and records once their content has moved, `next-steps.md` included. Ask before removing anything that is not purely a list of work or a record of it.
8. Add a short section to the project's instructions (`AGENTS.md` or `CLAUDE.md`, whichever it has) saying that its work is planned in `backlog.md` and `history.md` under the `project-planning` skill, and that the user's actions are in its project in the to-do app.
9. Commit in this project only. Tell the user what moved where.
