-- Deletes a tag, which also takes it off every to-do that has it.
-- Usage: osascript delete-tag.applescript <id>

on run argv
	if (count of argv) is not 1 then error "usage: delete-tag.applescript <id>"
	tell application "Things3"
		set theTag to tag id (item 1 of argv)
		-- Looked up first, so that an unknown id fails rather than doing nothing.
		get name of theTag
		delete theTag
	end tell
end run
