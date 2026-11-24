#!/bin/sh
# Asks for any uncommitted change to the project's backlog.md, such as items the
# hub project added, to be committed before other work. The planning files are in
# meta/, or in the project root where the project has not moved them.

dir="${CLAUDE_PROJECT_DIR:-.}"

for folder in meta/ ""; do
	[ -n "$(git -C "$dir" status --porcelain -- "${folder}backlog.md" 2>/dev/null)" ] || continue

	echo "${folder}backlog.md has uncommitted changes, probably items added by the hub project. Before anything else, commit ${folder}backlog.md on its own, with a ${folder}history.md entry noting which items came from the hub project."
done
