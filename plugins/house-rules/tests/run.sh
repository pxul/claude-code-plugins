#!/bin/sh
# Runs the session-start hook as Claude Code would and checks what it prints.

set -u

here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)
failed=0

# check prints ok or FAIL for one case: check <description> <want> <got>.
check() {
	if [ "$2" = "$3" ]; then
		echo "ok   $1"
	else
		echo "FAIL $1"
		echo "     want: $2"
		echo "     got:  $3"
		failed=1
	fi
}

check "prints RULES.md" "$(cat "$root/RULES.md")" "$(CLAUDE_PLUGIN_ROOT=$root sh "$root/hooks/print-rules.sh" 2>&1)"

exit $failed
