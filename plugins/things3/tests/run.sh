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

# listed_line prints a to-do's line in a list: listed_line <list> <id>.
listed_line() {
	run list-todos "$1" | grep "^$2$tab"
}

# The when date moves a to-do between Today, Upcoming, Someday and Anytime;
# the deadline is set and cleared apart from it.
today=$(date '+%Y-%m-%d')
next_week=$(date -v+7d '+%Y-%m-%d')
fortnight=$(date -v+14d '+%Y-%m-%d')
todo=$(run add-todo "zz test dates" "" project "$project")
rest="${tab}$project_name${tab}${tab}"

run set-when "$todo" today
check "set-when today puts the to-do in Today" "$todo${tab}zz test dates${tab}$today${tab}$rest" "$(listed_line today "$todo")"

run set-when "$todo" "$next_week"
check "set-when a date puts the to-do in Upcoming" "$todo${tab}zz test dates${tab}$next_week${tab}$rest" "$(listed_line upcoming "$todo")"
check "set-when a date takes the to-do out of Today" "" "$(listed_line today "$todo")"

# A project's Someday to-dos are in no list, the Someday list included; only
# a to-do outside a project shows there, and the cases may not make one.
run set-when "$todo" someday
check "set-when someday takes the to-do out of Today, Upcoming and Anytime" "" \
	"$(listed_line today "$todo")$(listed_line upcoming "$todo")$(listed_line anytime "$todo")"
check "set-when someday takes the to-do out of Anytime" "" "$(listed_line anytime "$todo")"

run set-when "$todo" none
check "set-when none puts the to-do back in Anytime" "$todo${tab}zz test dates${tab}${tab}$rest" "$(listed_line anytime "$todo")"
check "set-when none takes the to-do out of Someday" "" "$(listed_line someday "$todo")"

run set-deadline "$todo" "$fortnight"
check "set-deadline sets the deadline" "$todo${tab}zz test dates${tab}${tab}$fortnight$rest" "$(listed_line anytime "$todo")"

run set-deadline "$todo" none
check "set-deadline none clears the deadline" "$todo${tab}zz test dates${tab}${tab}$rest" "$(listed_line anytime "$todo")"

run set-when "$todo" 2026-13-40
check "set-when rejects a bad date" 1 $?
run set-when "$todo" tonight
check "set-when rejects an unknown word" 1 $?
run set-deadline "$todo" someday
check "set-deadline rejects anything but a date or none" 1 $?
check "a rejected change leaves the to-do as it was" "$todo${tab}zz test dates${tab}${tab}$rest" "$(listed_line anytime "$todo")"

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
