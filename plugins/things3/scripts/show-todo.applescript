-- Prints one to-do as "field: value" lines, then a "notes:" line followed by
-- the notes as they are, to the end of the output.
-- Usage: osascript show-todo.applescript <id>

on run argv
	if (count of argv) is not 1 then error "usage: show-todo.applescript <id>"
	tell application "Things3"
		set todo to to do id (item 1 of argv)

		set todoStatus to status of todo
		if todoStatus is completed then
			set statusText to "completed"
		else if todoStatus is canceled then
			set statusText to "canceled"
		else
			set statusText to "open"
		end if

		set projectName to ""
		if project of todo is not missing value then set projectName to name of project of todo
		set areaName to ""
		if area of todo is not missing value then set areaName to name of area of todo

		return "id: " & id of todo & linefeed & ¬
			"name: " & name of todo & linefeed & ¬
			"status: " & statusText & linefeed & ¬
			"project: " & projectName & linefeed & ¬
			"area: " & areaName & linefeed & ¬
			"notes:" & linefeed & notes of todo
	end tell
end run
