# Work rules

How to work in every session and every project.

## Working Directory Scope

Do not read, write, search, or act on files or systems outside the current working directory unless the user explicitly requests it in the current message. This applies to every session and every task.

The one exception is reading: a project's `AGENTS.md` may name other directories, or say how to find them, as in scope for reading while working in that project, and reading those counts as explicitly requested. Writing outside the current working directory always needs the user's permission first, whatever a project's instructions say.

## Asking Questions

Never use the AskUserQuestion tool (the multiple-choice option-picker UI) to ask questions. Ask clarifying and design questions conversationally, in prose, and one at a time: pose a single question, wait for the answer, then ask the next. This gives the user room to push back and ask their own clarifying questions rather than being boxed into preset options or a batch.

## Email

Any project may draft an email for the user to send, saved as a record beside the messages it answers. Keep each email as a `.md` record giving the date, direction, sender or recipient, subject and text. Once an original `.eml` is copied into its record, delete it, keeping any attachment that matters, such as a form, under its own name.

When a saved email quotes earlier messages in its thread, record each message as its own dated `.md`, linking to the one it answers.

## Checking Changes

Run the project's own build, test, lint and format commands to check a change. Do not install tools to do it; if a check is missing or fails for reasons outside the change, say so.

## Commit Messages

A commit you make yourself, where a project's instructions or the user's global instructions let you commit, ends with one trailer naming you as co-author, such as `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`. Commits the user makes carry no trailers, including a message you draft for them to use. Pull request descriptions carry no trailers either: no "generated with" line, nothing below the body.

In a repository where you commit your own changes, a follow-up that only corrects your previous commit, made in the same session before it is pushed, is amended into that commit or squashed with it, so the history keeps one commit per change. Never rewrite pushed commits.
