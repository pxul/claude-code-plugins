#!/bin/sh
# Runs the things3 scripts against the real Things3, inside a throwaway project
# that is deleted at the end, whether or not the cases pass. Touches nothing
# outside that project. Every to-do a case makes has a name starting
# "zz test", so the last case can find any that ended up outside it.

set -u

here=$(cd "$(dirname "$0")" && pwd)
scripts="$here/../scripts"
project_name="zz Things skill test"
project_notes=$(printf 'Folder: ~/zz-test\nSecond line')
tab=$(printf '\t')
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

# run runs one of the scripts: run <script> <argument>...
# Errors go to the terminal rather than into the captured output.
run() {
	script=$1
	shift
	osascript "$scripts/$script.applescript" "$@"
}

existing=$(osascript - "$project_name" <<'EOF'
on run argv
	tell application "Things3" to return count of (projects whose name is (item 1 of argv))
end run
EOF
)
if [ "$existing" != "0" ]; then
	echo "A project named \"$project_name\" already exists; delete it and run again." >&2
	exit 2
fi

project=$(osascript - "$project_name" "$project_notes" <<'EOF'
on run argv
	tell application "Things3" to return id of (make new project with properties {name:item 1 of argv, notes:item 2 of argv})
end run
EOF
)
[ -n "$project" ] || exit 2

# The project is deleted by id, so nothing else can be hit.
cleanup() {
	osascript - "$project" <<'EOF'
on run argv
	tell application "Things3" to delete project id (item 1 of argv)
end run
EOF
}
trap cleanup EXIT

# Create a to-do in the project, with notes, and read it back.
notes=$(printf 'Line one "quoted"\nLine two')
todo=$(run add-todo "zz test read back" "$notes" project "$project")
shown=$(run show-todo "$todo")
check "show-todo name" "name: zz test read back" "$(echo "$shown" | grep '^name: ')"
check "show-todo status" "status: open" "$(echo "$shown" | grep '^status: ')"
check "show-todo project" "project: $project_name" "$(echo "$shown" | grep '^project: ')"
check "show-todo notes" "$notes" "$(echo "$shown" | sed '1,/^notes:$/d')"

# A to-do in a project with no when date is in Anytime and in no other list.
# Fields: id, name, when, deadline, project, area, tags.
todo=$(run add-todo "zz test list me" "" project "$project")
listed=$(run list-todos anytime)
check "list-todos anytime has the to-do" \
	"$todo${tab}zz test list me${tab}${tab}${tab}$project_name${tab}${tab}" \
	"$(echo "$listed" | grep "^$todo$tab")"
for list in inbox today upcoming someday logbook; do
	listed=$(run list-todos $list)
	check "list-todos $list runs" 0 $?
	check "list-todos $list leaves out the to-do" "" "$(echo "$listed" | grep "^$todo$tab")"
done
listed=$(run list-todos logbook 3)
check "list-todos logbook 3 runs" 0 $?
check "list-todos logbook 3 lists at most 3" yes "$([ "$(echo "$listed" | grep -c .)" -le 3 ] && echo yes)"
listed=$(run list-todos tomorrow)
check "list-todos rejects an unknown list" 1 $?

# Areas are listed as id and name.
areas=$(run list-areas)
check "list-areas runs" 0 $?
check "list-areas prints two fields a line" "" "$(echo "$areas" | awk -F'\t' 'NF && NF != 2')"

# A project is listed as id, name and area, then its notes, a tab before each line.
projects=$(run list-projects)
check "list-projects runs" 0 $?
check "list-projects has the project and its notes" \
	"$(printf '%s\t%s\t\n\tFolder: ~/zz-test\n\tSecond line' "$project" "$project_name")" \
	"$(echo "$projects" | awk -v id="$project" -F'\t' '$1 == id { on = 1; print; next } on && /^\t/ { print; next } { on = 0 }')"

# Nothing the cases made may be outside the test project.
escaped=$(osascript - "$project" <<'EOF'
on run argv
	tell application "Things3"
		set out to ""
		repeat with todo in (to dos whose name starts with "zz test")
			if project of todo is missing value then
				set out to out & id of todo & " " & name of todo & linefeed
			else if id of project of todo is not (item 1 of argv) then
				set out to out & id of todo & " " & name of todo & linefeed
			end if
		end repeat
		return out
	end tell
end run
EOF
)
check "nothing is left outside the test project" "" "$escaped"

exit $failed
