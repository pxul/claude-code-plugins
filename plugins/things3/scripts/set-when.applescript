-- Sets or clears a to-do's when date.
-- Usage: osascript set-when.applescript <id> <today|YYYY-MM-DD|someday|none>
-- none clears the when date, which puts the to-do in Anytime.

on run argv
	if (count of argv) is not 2 then error "usage: set-when.applescript <id> <today|YYYY-MM-DD|someday|none>"
	set whenText to item 2 of argv
	-- Parsed before Things3 is touched, so that a bad date changes nothing.
	if {"today", "someday", "none"} does not contain whenText then set whenDate to parseDate(whenText)
	tell application "Things3"
		set todo to to do id (item 1 of argv)
		if whenText is "today" then
			schedule todo for (current date)
		else if whenText is "someday" then
			move todo to list id "TMSomedayListSource"
		else if whenText is "none" then
			move todo to list id "TMNextListSource"
		else
			schedule todo for whenDate
		end if
	end tell
end run

-- parseDate returns the date written as YYYY-MM-DD, and fails on anything
-- else, including dates that do not exist.
on parseDate(dateText)
	set usage to "set-when.applescript: " & dateText & " is not today, someday, none or a date written YYYY-MM-DD"
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
