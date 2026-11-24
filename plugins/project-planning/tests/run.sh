#!/bin/sh
# Runs the session-start hook against throwaway git repositories, one per case,
# which are deleted at the end whether or not the cases pass.

set -u

here=$(cd "$(dirname "$0")" && pwd)
script="$here/../hooks/backlog-check.sh"
root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
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

# repo makes a git repository with a committed backlog and prints its path:
# repo <name> <backlog path>.
repo() {
	dir="$root/$1"
	mkdir -p "$dir/$(dirname "$2")"
	git -C "$dir" init -q
	printf '# Backlog\n' >"$dir/$2"
	git -C "$dir" add "$2"
	git -C "$dir" -c user.name=test -c user.email=test@example.com -c commit.gpgsign=false commit -qm "Start the backlog"
	echo "$dir"
}

# hook runs the hook as a session would in the project: hook <project dir>.
hook() {
	CLAUDE_PROJECT_DIR=$1 sh "$script"
}

dir=$(repo changed backlog.md)
printf '\n## New item\n' >>"$dir/backlog.md"
check "uncommitted backlog.md change" "backlog.md has uncommitted changes, probably items added by the hub project. Before anything else, commit backlog.md on its own, with a history.md entry noting which items came from the hub project." "$(hook "$dir")"

dir=$(repo meta-changed meta/backlog.md)
printf '\n## New item\n' >>"$dir/meta/backlog.md"
check "uncommitted meta/backlog.md change" "meta/backlog.md has uncommitted changes, probably items added by the hub project. Before anything else, commit meta/backlog.md on its own, with a meta/history.md entry noting which items came from the hub project." "$(hook "$dir")"

dir=$(repo unchanged backlog.md)
check "unchanged backlog.md" "" "$(hook "$dir")"

dir="$root/no-backlog"
mkdir "$dir"
git -C "$dir" init -q
check "no backlog.md" "" "$(hook "$dir")"

dir="$root/not-a-repo"
mkdir "$dir"
printf '# Backlog\n' >"$dir/backlog.md"
check "not a git repository, on either output" "" "$(hook "$dir" 2>&1)"

matcher=$(sed -n 's/.*"matcher": "\(.*\)".*/\1/p' "$here/../hooks/hooks.json")
check "runs at startup and after /clear" "startup|clear" "$matcher"

exit $failed
