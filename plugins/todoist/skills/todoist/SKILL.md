---
name: todoist
description: How the house planning conventions map onto Todoist through the Todoist connector: areas, Someday, cancelling, reading completions, time blocks and a project's Folder line. Use whenever a task reads from or writes to Todoist.
---

# Todoist

Todoist is reached through the Todoist connector, whose tools are named `mcp__claude_ai_Todoist__*` (`find-tasks`, `add-tasks`, `find-activity` and so on). Each tool's own description says how to call it. This skill says how the `project-planning` conventions are kept in Todoist, which has no areas, no Someday list and no cancelled state. When to change things, and whether to ask first, is for the project using this skill to say.

If the connector's tools are missing, the connector is not connected: say so and stop, rather than writing the change anywhere else.

## Projects and areas

- **An area** is a parent project. Its child projects are the area's projects, and tasks directly in the parent are the area's own loose tasks.
- **A project's Folder line:** the description of a project that belongs to a folder on disk starts with its `Folder: ~/path/to/project` line. Find a project from its folder by reading project descriptions, not by its name.
- **The inbox** is Todoist's Inbox project.

## Dates and lists

- **Today** is a task due today. An action that cannot wait gets today's date as it is added.
- **Someday** is the `someday` label: a task to come back to, not one to do now. An undated task without the label can be done any time, which is not the same thing.
- **A block** of time is a task with a due time and a duration. A task with no date yet gets its first date or time, and its duration, from `update-tasks` with a `dueString` and a `duration`, since `reschedule-tasks` refuses a task with no due date. `reschedule-tasks` moves a task that already has a date to another date or time, and sets its duration, without replacing a repeating task's pattern.
- **A missed or partly done task**, one whose date or time passed with it undone or only part done, is moved to its new slot with `reschedule-tasks`, so everything said about it stays on one task. A partly done task first gets the comment `project-planning` asks for, added with `add-comments`.
- **A miss count** ends the description of a missed task, such as `Missed 3 times: 2, 5 and 6 November.`, updated each time it is moved after a miss, so a task missed again and again stands out. This holds for every task, timed or not, except a block for ongoing work with a weekly time budget, named after the work ("Reading") rather than a piece of it: each such block is one of many interchangeable hours, so its misses show against the week's budget, not on the task.

## Finishing a task

- **Completing:** complete the task. A repeating task completed only moves to its next date.
- **Cancelling:** Todoist has no cancelled state, so add the `cancelled` label and then complete the task. The label is what tells a cancelled task from a done one.
- **Deleting** is for mistakes such as duplicates, as `project-planning` says, since a deleted task leaves no record.

## Reading what was done

Read completions from the activity log, not from the list of completed tasks: call `find-activity` with `objectType` `task`, `eventType` `completed`, the user's own id (from `user-info`) as `initiatorId`, and the date range. The list of completed tasks misses repeating tasks, which stay open and only move to their next date when ticked off. Each completed event gives the due date of the occurrence that was completed and the task's labels, so a `cancelled` label shows which were cancelled.

A completion is recorded at the time it is made, and its time cannot be set to an earlier date. When a task was done earlier than it is ticked off, say so in a comment on it if the date matters.
