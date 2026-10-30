#!/bin/sh
# Asks for any uncommitted change to the project's backlog.md, such as items the
# hub project added, to be committed before other work.

dir="${CLAUDE_PROJECT_DIR:-.}"

[ -n "$(git -C "$dir" status --porcelain -- backlog.md 2>/dev/null)" ] || exit 0

echo "backlog.md has uncommitted changes, probably items added by the hub project. Before anything else, commit backlog.md on its own, with a history.md entry noting which items came from the hub project."
