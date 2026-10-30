-- Creates a project and prints its id.
-- Usage: osascript add-project.applescript <name> <notes> [area <id>]

on run argv
	set argCount to count of argv
	if argCount is not 2 and argCount is not 4 then error "usage: add-project.applescript <name> <notes> [area <id>]"
	if argCount is 4 and item 3 of argv is not "area" then error "add-project.applescript: the third argument must be area"
	tell application "Things3"
		-- Built inside the tell block, so that notes is Things3's property.
		set props to {name:item 1 of argv, notes:item 2 of argv}
		-- Look the area up first, so that a bad id fails before anything is made.
		if argCount is 4 then
			set target to area id (item 4 of argv)
			get name of target
		end if
		set newProject to make new project with properties props
		if argCount is 4 then set area of newProject to target
		return id of newProject
	end tell
end run
