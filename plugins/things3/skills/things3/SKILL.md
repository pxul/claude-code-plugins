---
name: things3
description: Read and change Things3 through AppleScript — the Inbox, Today, Upcoming, Anytime, Someday and Logbook lists, areas, projects, to-dos, when dates, deadlines and tags. Use whenever a task reads from or writes to Things3.
---

# Things3

Scripts for reading and changing Things3 on this Mac through `osascript`. When to change things, and whether to ask first, is for the project using this skill to say.

## Running the scripts

The scripts are in the plugin's `scripts/` directory, two levels above this skill's base directory:

```
osascript <skill base directory>/../../scripts/<script>.applescript <argument>...
```

Arguments are passed as they are, so names and notes may hold quotes and line breaks. A script that fails prints the reason to standard error and exits 1, having changed nothing. macOS asks once for permission for the terminal to control Things3.

Every change acts on an id, never a name. Find ids by listing first.

## Reading

| Script | Prints |
|---|---|
| `list-todos.applescript <list> [<max>]` | The to-dos in `inbox`, `today`, `upcoming`, `anytime`, `someday` or `logbook`, one line each. `<max>` reads only that many entries from the top, for the Logbook in particular. |
| `show-todo.applescript <id>` | One to-do as `field: value` lines (`id`, `name`, `status`, `project`, `area`, `when`, `deadline`, `tags`), then `notes:` and the notes as they are, to the end of the output. |
| `list-areas.applescript` | Each area as id, name. |
| `list-projects.applescript` | Each open project as id, name, area, then each line of its notes with a tab in front. |
| `list-tags.applescript` | Each tag as id, name. |

Lines are tab-separated. A to-do's line in `list-todos` is id, name, when date, deadline, project, area, tags. Dates are `YYYY-MM-DD`, and a field not set is empty. Tags are comma-separated, in Things3's order. `status` is `open`, `completed` or `canceled`.

## Changing

| Script | Does |
|---|---|
| `add-todo.applescript <name> <notes> [project\|area <id>]` | Creates a to-do in the Inbox, or in the project or area given, and prints its id. Pass `""` for no notes. |
| `add-project.applescript <name> <notes> [area <id>]` | Creates a project, in the area if given, and prints its id. |
| `set-when.applescript <id> <today\|YYYY-MM-DD\|someday\|none>` | Sets the when date. `none` clears it, which puts the to-do in Anytime. |
| `set-deadline.applescript <id> <YYYY-MM-DD\|none>` | Sets or clears the deadline. |
| `move-todo.applescript <id> project\|area <id>` | Moves a to-do to a project or area, out of the one it was in. |
| `set-status.applescript <id> <open\|completed\|canceled>` | Completes, cancels or reopens a to-do. |
| `delete-todo.applescript <id>` | Moves a to-do to the Trash. Refuses a project's id. |
| `add-tag.applescript <to-do id> <tag name>` | Adds an existing tag to a to-do. Refuses a tag that does not exist, rather than making one from a mistyped name. |
| `remove-tag.applescript <to-do id> <tag name>` | Removes a tag from a to-do. |
| `create-tag.applescript <name>` | Creates a tag and prints its id. Refuses a name already taken or holding a comma. |
| `delete-tag.applescript <id>` | Deletes a tag, taking it off every to-do that has it. |

## How Things3 behaves

- **Someday:** the Someday list holds only to-dos outside projects. A to-do in a project set to Someday is in no list; it shows only inside its project.
- **The Logbook:** a completed or cancelled to-do stays in Anytime for a moment, and reaches the Logbook when Things3 logs it, which depends on the user's Things3 settings. The scripts read, reopen and delete a logged to-do by id like any other.
- **The Trash:** `delete-todo` moves a to-do to the Trash, where the user can restore it. The scripts never empty the Trash.

## Limits

- AppleScript cannot create repeating to-dos or headings, and the scripts cannot set This Evening.
- The `things:///` URL scheme cannot create repeating to-dos either. It can create headings, but only within a new project made with its `json` command, and can add a to-do under an existing heading with `add` and the `list-id` and `heading` parameters. It can set This Evening with `when=evening`. It does not give back the id of what it makes, and its `update` commands need the auth token from Things3 → Settings → General → Enable Things URLs → Manage. The scripts do not use it.
- Names holding a tab or a line break would split a line of output.
