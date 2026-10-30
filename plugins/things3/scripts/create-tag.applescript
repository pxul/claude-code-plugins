-- Creates a tag and prints its id. Refuses a name already taken, and one with
-- a comma, which would read as two tags in a to-do's tag names.
-- Usage: osascript create-tag.applescript <name>

on run argv
	if (count of argv) is not 1 then error "usage: create-tag.applescript <name>"
	set tagName to item 1 of argv
	if tagName contains "," then error "create-tag.applescript: a tag name cannot contain a comma"
	tell application "Things3"
		if (count of (tags whose name is tagName)) is not 0 then error "create-tag.applescript: there is already a tag named " & tagName
		return id of (make new tag with properties {name:tagName})
	end tell
end run
