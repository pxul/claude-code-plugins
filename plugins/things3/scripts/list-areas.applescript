-- Prints Things3's areas, one tab-separated line each: id, name.
-- Usage: osascript list-areas.applescript

on run argv
	if (count of argv) is not 0 then error "usage: list-areas.applescript"
	set out to {}
	tell application "Things3"
		repeat with theArea in areas
			set end of out to id of theArea & tab & name of theArea
		end repeat
	end tell
	set AppleScript's text item delimiters to linefeed
	return out as text
end run
