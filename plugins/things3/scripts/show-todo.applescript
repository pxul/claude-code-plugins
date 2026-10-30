-- Prints one to-do as "field: value" lines, then a "notes:" line followed by
-- the notes as they are, to the end of the output. Dates are YYYY-MM-DD, empty
-- when not set; tags are comma-separated.
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
			"when: " & my isoDate(activation date of todo) & linefeed & ¬
			"deadline: " & my isoDate(due date of todo) & linefeed & ¬
			"tags: " & tag names of todo & linefeed & ¬
			"notes:" & linefeed & notes of todo
	end tell
end run

-- isoDate returns a date as YYYY-MM-DD, or "" for missing value.
on isoDate(theDate)
	if theDate is missing value then return ""
	set y to year of theDate as integer
	set m to month of theDate as integer
	set d to day of theDate
	return (y as text) & "-" & text -2 thru -1 of ("0" & m) & "-" & text -2 thru -1 of ("0" & d)
end isoDate
