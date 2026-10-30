-- Adds a tag to a to-do. The tag must exist already: Things3 would otherwise
-- make a new tag from a mistyped name.
-- Usage: osascript add-tag.applescript <to-do id> <tag name>

on run argv
	if (count of argv) is not 2 then error "usage: add-tag.applescript <to-do id> <tag name>"
	set tagName to item 2 of argv
	tell application "Things3"
		if (count of (tags whose name is tagName)) is 0 then error "add-tag.applescript: there is no tag named " & tagName
		set todo to to do id (item 1 of argv)
		set todoTags to my splitTags(tag names of todo)
		if todoTags does not contain tagName then
			set end of todoTags to tagName
			set tag names of todo to my joinTags(todoTags)
		end if
	end tell
end run

-- splitTags returns the names in a to-do's comma-separated tag names.
on splitTags(tagText)
	if tagText is "" then return {}
	set AppleScript's text item delimiters to ", "
	return text items of tagText
end splitTags

-- joinTags returns tag names as a to-do's comma-separated tag names.
on joinTags(tagList)
	set AppleScript's text item delimiters to ", "
	return tagList as text
end joinTags
