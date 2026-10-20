#!/bin/sh
# Prompts the morning review when the project's next-steps.md has a "Reviewed"
# date other than today. Silent in a project without a next-steps.md.

file="${CLAUDE_PROJECT_DIR:-.}/next-steps.md"
[ -f "$file" ] || exit 0

today=$(LC_ALL=C date '+%-d %B %Y')
reviewed=$(sed -n 's/^Reviewed \([0-9]* [A-Za-z]* [0-9]*\).*/\1/p' "$file" | head -n 1)

[ "$reviewed" = "$today" ] && exit 0

echo "next-steps.md was last reviewed on ${reviewed:-an unknown date}; today is $today. Before anything else, run the morning review described by the project-planning:morning-review skill."
