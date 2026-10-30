-- Prints Things3's tags, one tab-separated line each: id, name.
-- Usage: osascript list-tags.applescript

on run argv
	if (count of argv) is not 0 then error "usage: list-tags.applescript"
	set out to {}
	tell application "Things3"
		repeat with theTag in tags
			set end of out to id of theTag & tab & name of theTag
		end repeat
	end tell
	set AppleScript's text item delimiters to linefeed
	return out as text
end run
