#!/bin/sh
# Runs the message hook as Claude Code would and checks what it prints.

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

# The minute can turn while the hook runs, so the line may match the time
# just before it or just after.
before=$(LC_ALL=C date '+Time: %H:%M, %A %-d %B %Y')
got=$(CLAUDE_PLUGIN_ROOT=$root sh "$root/hooks/print-time.sh" 2>&1)
after=$(LC_ALL=C date '+Time: %H:%M, %A %-d %B %Y')
if [ "$got" = "$after" ]; then
	want=$after
else
	want=$before
fi
check "prints the local time, day and date" "$want" "$got"

# hooks.json runs the script on every message.
command=$(python3 -c '
import json, sys
hooks = json.load(open(sys.argv[1]))["hooks"]["UserPromptSubmit"]
print(hooks[0]["hooks"][0]["command"])
' "$root/hooks/hooks.json" 2>&1)
got=$(CLAUDE_PLUGIN_ROOT=$root sh -c "$command" 2>&1)
check "hooks.json runs it on each message" "$(CLAUDE_PLUGIN_ROOT=$root sh "$root/hooks/print-time.sh")" "$got"

exit $failed
