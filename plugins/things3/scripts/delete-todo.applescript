-- Moves a to-do to the Trash. A project's id is refused, as "to do id" does
-- not find projects.
-- Usage: osascript delete-todo.applescript <id>

on run argv
	if (count of argv) is not 1 then error "usage: delete-todo.applescript <id>"
	set todoId to item 1 of argv
	tell application "Things3"
		-- A logged to-do can be read through "to do id" alone, but deleted only
		-- through the Logbook.
		try
			delete (to do id todoId of list id "TMLogbookListSource")
		on error
			delete to do id todoId
		end try
	end tell
end run
