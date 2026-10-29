-- Creates a to-do and prints its id.
-- Usage: osascript add-todo.applescript <name> <notes> [project|area <id>]
-- With no project or area, the to-do goes to the Inbox.

on run argv
	set argCount to count of argv
	if argCount is not 2 and argCount is not 4 then error "usage: add-todo.applescript <name> <notes> [project|area <id>]"
	tell application "Things3"
		-- Built inside the tell block, so that notes is Things3's property.
		set props to {name:item 1 of argv, notes:item 2 of argv}
		-- Look the target up first, so that a bad id fails before anything is made.
		if argCount is 4 then
			if item 3 of argv is "project" then
				set target to project id (item 4 of argv)
			else if item 3 of argv is "area" then
				set target to area id (item 4 of argv)
			else
				error "add-todo.applescript: the third argument must be project or area"
			end if
			get name of target
		end if
		-- "at beginning of project" leaves the to-do in the Inbox, so the
		-- project or area is set after the to-do is made.
		set newTodo to make new to do with properties props
		if argCount is 4 then
			if item 3 of argv is "project" then
				set project of newTodo to target
			else
				set area of newTodo to target
			end if
		end if
		return id of newTodo
	end tell
end run
