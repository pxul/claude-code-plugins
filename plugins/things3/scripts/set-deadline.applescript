-- Sets or clears a to-do's deadline.
-- Usage: osascript set-deadline.applescript <id> <YYYY-MM-DD|none>

on run argv
	if (count of argv) is not 2 then error "usage: set-deadline.applescript <id> <YYYY-MM-DD|none>"
	set deadlineText to item 2 of argv
	-- Parsed before Things3 is touched, so that a bad date changes nothing.
	if deadlineText is not "none" then set deadline to parseDate(deadlineText)
	tell application "Things3"
		set todo to to do id (item 1 of argv)
		-- Things3 will not set the due date to missing value; it must be deleted.
		if deadlineText is "none" then
			delete due date of todo
		else
			set due date of todo to deadline
		end if
	end tell
end run

-- parseDate returns the date written as YYYY-MM-DD, and fails on anything
-- else, including dates that do not exist.
on parseDate(dateText)
	set usage to "set-deadline.applescript: " & dateText & " is not none or a date written YYYY-MM-DD"
	if length of dateText is not 10 or character 5 of dateText is not "-" or character 8 of dateText is not "-" then error usage
	try
		set y to (text 1 thru 4 of dateText) as integer
		set m to (text 6 thru 7 of dateText) as integer
		set d to (text 9 thru 10 of dateText) as integer
	on error
		error usage
	end try
	if m < 1 or m > 12 or d < 1 or d > 31 then error usage
	set theDate to current date
	set day of theDate to 1
	set year of theDate to y
	set month of theDate to m
	set day of theDate to d
	set time of theDate to 0
	-- A day past the end of the month rolls into the next one.
	if day of theDate is not d then error usage
	return theDate
end parseDate
