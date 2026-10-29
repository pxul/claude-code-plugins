-- Prints Things3's open projects. Each is one tab-separated line, id, name,
-- area, followed by the lines of its notes, each with a tab in front.
-- Usage: osascript list-projects.applescript

on run argv
	if (count of argv) is not 0 then error "usage: list-projects.applescript"
	set out to {}
	tell application "Things3"
		repeat with theProject in (projects whose status is open)
			set areaName to ""
			if area of theProject is not missing value then set areaName to name of area of theProject
			set end of out to id of theProject & tab & name of theProject & tab & areaName
			-- Fetched first, so that AppleScript, not Things3, splits it.
			set projectNotes to notes of theProject
			repeat with noteLine in paragraphs of projectNotes
				set end of out to tab & noteLine
			end repeat
		end repeat
	end tell
	set AppleScript's text item delimiters to linefeed
	return out as text
end run
