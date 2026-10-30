-- Removes a tag from a to-do. A tag the to-do lacks is left alone.
-- Usage: osascript remove-tag.applescript <to-do id> <tag name>

on run argv
	if (count of argv) is not 2 then error "usage: remove-tag.applescript <to-do id> <tag name>"
	set tagName to item 2 of argv
	tell application "Things3"
		set todo to to do id (item 1 of argv)
		set kept to {}
		repeat with todoTag in my splitTags(tag names of todo)
			if contents of todoTag is not tagName then set end of kept to contents of todoTag
		end repeat
		set AppleScript's text item delimiters to ", "
		set tag names of todo to kept as text
	end tell
end run

-- splitTags returns the names in a to-do's comma-separated tag names.
on splitTags(tagText)
	if tagText is "" then return {}
	set AppleScript's text item delimiters to ", "
	return text items of tagText
end splitTags
