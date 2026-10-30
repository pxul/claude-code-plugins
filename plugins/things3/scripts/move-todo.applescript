-- Moves a to-do to a project or an area, out of the one it was in.
-- Usage: osascript move-todo.applescript <id> project|area <id>

on run argv
	if (count of argv) is not 3 then error "usage: move-todo.applescript <id> project|area <id>"
	set targetKind to item 2 of argv
	if targetKind is not "project" and targetKind is not "area" then error "move-todo.applescript: the second argument must be project or area"
	tell application "Things3"
		set todo to to do id (item 1 of argv)
		-- Look the target up first, so that a bad id fails before anything moves.
		if targetKind is "project" then
			set target to project id (item 3 of argv)
		else
			set target to area id (item 3 of argv)
		end if
		get name of target
		if targetKind is "project" then
			set project of todo to target
		else
			set area of todo to target
		end if
	end tell
end run
