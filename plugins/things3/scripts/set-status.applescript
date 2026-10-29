-- Sets a to-do's status. Completed and canceled to-dos go to the Logbook;
-- open brings one back.
-- Usage: osascript set-status.applescript <id> <open|completed|canceled>

on run argv
	if (count of argv) is not 2 then error "usage: set-status.applescript <id> <open|completed|canceled>"
	set statusText to item 2 of argv
	if {"open", "completed", "canceled"} does not contain statusText then error "set-status.applescript: " & statusText & " is not open, completed or canceled"
	tell application "Things3"
		set todo to to do id (item 1 of argv)
		if statusText is "open" then
			set status of todo to open
		else if statusText is "completed" then
			set status of todo to completed
		else
			set status of todo to canceled
		end if
	end tell
end run
