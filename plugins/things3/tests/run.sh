#!/bin/sh
# Runs the things3 scripts against the real Things3, inside a throwaway area
# and projects that are deleted at the end, whether or not the cases pass.
# Touches nothing outside them. Every to-do a case makes has a name starting
# "zz test", so the last case can find any that ended up outside them.

set -u

here=$(cd "$(dirname "$0")" && pwd)
scripts="$here/../scripts"
project_name="zz Things skill test"
project_notes=$(printf 'Folder: ~/zz-test\nSecond line')
area_name="zz Things skill test area"
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

existing=$(osascript - "$project_name" "$area_name" <<'EOF'
on run argv
	tell application "Things3" to return (count of (projects whose name starts with (item 1 of argv))) + (count of (areas whose name is (item 2 of argv)))
end run
EOF
)
if [ "$existing" != "0" ]; then
	echo "A project named \"$project_name...\" or an area named \"$area_name\" already exists; delete it and run again." >&2
	exit 2
fi

area=$(osascript - "$area_name" <<'EOF'
on run argv
	tell application "Things3" to return id of (make new area with properties {name:item 1 of argv})
end run
EOF
)
[ -n "$area" ] || exit 2

project=$(osascript - "$project_name" "$project_notes" <<'EOF'
on run argv
	tell application "Things3" to return id of (make new project with properties {name:item 1 of argv, notes:item 2 of argv})
end run
EOF
)
# The ids of every project the cases make, for the cleanup and the last case.
test_projects=$project

# is_test is an AppleScript handler, shared by the cleanup and the last case:
# isTest(todo, areaId, projectIds) is true for a to-do in the test area or a
# test project.
is_test='
on isTest(todo, areaId, projectIds)
	tell application "Things3"
		if project of todo is not missing value then return projectIds contains (id of project of todo)
		if area of todo is not missing value then return (id of area of todo) is areaId
		return false
	end tell
end isTest'

# Everything is deleted by id, so nothing else can be hit. Logged to-dos are
# no longer among their project's or area's, so they are found in the Logbook.
# Ids are collected before anything is deleted, as deleting shifts the lists.
cleanup() {
	left=$(osascript - "$area" $test_projects <<EOF
on run argv
	set areaId to item 1 of argv
	set projectIds to rest of argv
	tell application "Things3"
		set logbook to list id "TMLogbookListSource"
		set doomed to {}
		repeat with todo in to dos of logbook
			if my isTest(todo, areaId, projectIds) then set end of doomed to id of todo
		end repeat
		repeat with todoId in doomed
			try
				delete (to do id todoId of logbook)
			end try
		end repeat
		set doomed to {}
		repeat with todo in to dos of area id areaId
			if class of todo is not project then set end of doomed to id of todo
		end repeat
		repeat with todoId in doomed
			try
				delete to do id todoId
			end try
		end repeat
		repeat with projectId in projectIds
			try
				delete project id projectId
			end try
		end repeat
		delete area id areaId
		return (count of (to dos of logbook whose name starts with "zz test")) + (count of (to dos whose name starts with "zz test"))
	end tell
end run
$is_test
EOF
)
	if [ "$left" != "0" ]; then
		echo "WARNING: $left to-dos named \"zz test...\" are still in Things3" >&2
	fi
}
trap cleanup EXIT
[ -n "$project" ] || exit 2

# project_block prints a project's line in list-projects and its notes lines,
# or nothing for an empty id, which would otherwise match every project's notes.
project_block() {
	[ -n "$1" ] || return 0
	run list-projects | awk -v id="$1" -F'\t' '$1 == id { on = 1; print; next } on && /^\t/ { print; next } { on = 0 }'
}

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
	"$(project_block "$project")"

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

# Completed and canceled to-dos go to the Logbook; open brings one back.
todo=$(run add-todo "zz test status" "" project "$project")
run set-status "$todo" completed
check "set-status completed" "status: completed" "$(run show-todo "$todo" | grep '^status: ')"
# A completed to-do stays in Anytime for a moment.
sleep 2
check "a completed to-do is out of Anytime" "" "$(listed_line anytime "$todo")"
run set-status "$todo" open
check "set-status open" "status: open" "$(run show-todo "$todo" | grep '^status: ')"
check "a reopened to-do is back in Anytime" 1 "$(listed_line anytime "$todo" | grep -c .)"
run set-status "$todo" canceled
check "set-status canceled" "status: canceled" "$(run show-todo "$todo" | grep '^status: ')"
run set-status "$todo" done
check "set-status rejects an unknown status" 1 $?

# waiting_to_log prints the completed and canceled items outside the test
# project that Things3 has not yet moved to the Logbook.
waiting_to_log() {
	osascript - "$project" <<'EOF'
on run argv
	tell application "Things3"
		set out to {}
		repeat with todo in (to dos whose status is not open)
			set inTest to false
			if project of todo is not missing value then set inTest to (id of project of todo is (item 1 of argv))
			if not inTest then set end of out to id of todo & " " & name of todo
		end repeat
		repeat with theProject in (projects whose status is not open)
			set end of out to id of theProject & " " & name of theProject
		end repeat
		set AppleScript's text item delimiters to linefeed
		return out as text
	end tell
end run
EOF
}

# Logging moves every completed item in Things3 to the Logbook, so it is done
# only when the test's are the only ones waiting.
logged=$(run add-todo "zz test logged" "" project "$project")
run set-status "$logged" completed
waiting=$(waiting_to_log)
if [ -n "$waiting" ]; then
	echo "skip Logbook cases: other completed items are waiting to be logged:"
	echo "$waiting" | sed 's/^/     /'
else
	# Things3 will not log a to-do completed a moment ago.
	sleep 2
	osascript -e 'tell application "Things3" to log completed now'
	check "a completed to-do is in the Logbook once logged" 1 "$(run list-todos logbook 20 | grep -c "^$logged$tab")"
	check "a canceled to-do is in the Logbook once logged" 1 "$(run list-todos logbook 20 | grep -c "^$todo$tab")"
	check "show-todo finds a logged to-do" "status: completed" "$(run show-todo "$logged" | grep '^status: ')"
	run set-status "$logged" open
	check "set-status open reopens a logged to-do" "status: open" "$(run show-todo "$logged" | grep '^status: ')"
	check "a reopened logged to-do is back in Anytime" 1 "$(listed_line anytime "$logged" | grep -c .)"
	run delete-todo "$todo"
	check "delete-todo deletes a logged to-do" false "$(run list-todos logbook 20 | grep -q "^$todo$tab" && echo true || echo false)"
fi

# in_trash prints true if the item with the given id is in the Trash.
in_trash() {
	osascript - "$1" <<'EOF'
on run argv
	tell application "Things3" to return (id of to dos of list id "TMTrashListSource") contains (item 1 of argv)
end run
EOF
}

# Deleting moves a to-do to the Trash, and delete-todo will not delete a project.
todo=$(run add-todo "zz test delete" "" project "$project")
run delete-todo "$todo"
check "delete-todo puts the to-do in the Trash" true "$(in_trash "$todo")"
run delete-todo "$project"
check "delete-todo refuses a project" 1 $?
check "the refused project is not in the Trash" false "$(in_trash "$project")"

# A project can be made in an area, and a to-do moved between projects and
# areas.
second_name="zz Things skill test 2"
second=$(run add-project "$second_name" "Folder: ~/zz-test-2" area "$area")
[ -n "$second" ] && test_projects="$test_projects $second"
check "add-project makes the project in the area" \
	"$(printf '%s\t%s\t%s\n\tFolder: ~/zz-test-2' "$second" "$second_name" "$area_name")" \
	"$(project_block "$second")"

todo=$(run add-todo "zz test in area" "" area "$area")
check "add-todo puts a to-do in an area" "area: $area_name" "$(run show-todo "$todo" | grep '^area: ')"

todo=$(run add-todo "zz test move" "" project "$project")
run move-todo "$todo" project "$second"
check "move-todo to a project" "project: $second_name" "$(run show-todo "$todo" | grep '^project: ')"
run move-todo "$todo" area "$area"
shown=$(run show-todo "$todo")
check "move-todo to an area" "area: $area_name" "$(echo "$shown" | grep '^area: ')"
check "move-todo to an area takes the to-do out of its project" "project: " "$(echo "$shown" | grep '^project: ')"
run move-todo "$todo" project "$project"
shown=$(run show-todo "$todo")
check "move-todo from an area to a project" "project: $project_name" "$(echo "$shown" | grep '^project: ')"
check "move-todo to a project takes the to-do out of its area" "area: " "$(echo "$shown" | grep '^area: ')"
run move-todo "$todo" inbox
check "move-todo rejects an unknown target" 1 $?
run move-todo "$todo" project "$area"
check "move-todo rejects an area's id as a project's" 1 $?
check "a rejected move leaves the to-do where it was" "project: $project_name" "$(run show-todo "$todo" | grep '^project: ')"

# Nothing the cases made may be outside the test area and projects.
escaped=$(osascript - "$area" $test_projects <<EOF
on run argv
	set areaId to item 1 of argv
	set projectIds to rest of argv
	tell application "Things3"
		set out to ""
		repeat with todo in (to dos whose name starts with "zz test")
			if not my isTest(todo, areaId, projectIds) then set out to out & id of todo & " " & name of todo & linefeed
		end repeat
		return out
	end tell
end run
$is_test
EOF
)
check "nothing is left outside the test area and projects" "" "$escaped"

exit $failed
