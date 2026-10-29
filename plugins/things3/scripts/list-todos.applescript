-- Prints the to-dos in one of Things3's lists, one tab-separated line each:
-- id, name, when date, deadline, project, area, tags. Dates are YYYY-MM-DD,
-- empty when not set; tags are comma-separated. Projects in the list are left
-- out.
-- Usage: osascript list-todos.applescript <list> [<max>]
-- <list> is inbox, today, upcoming, anytime, someday or logbook. <max> caps
-- how many entries are read, from the top of the list.

on run argv
	set argCount to count of argv
	if argCount < 1 or argCount > 2 then error "usage: list-todos.applescript <list> [<max>]"
	set listId to listIdFor(item 1 of argv)
	set out to {}
	tell application "Things3"
		-- Read once, so that the list changing underneath does not shift the
		-- entries still to be printed.
		set entries to to dos of list id listId
		if argCount is 2 then
			set wanted to (item 2 of argv) as integer
			if wanted < 1 then error "list-todos.applescript: <max> must be 1 or more"
			if wanted < (count of entries) then set entries to items 1 thru wanted of entries
		end if
		repeat with todo in entries
			if class of todo is not project then set end of out to my todoLine(todo)
		end repeat
	end tell
	set AppleScript's text item delimiters to linefeed
	return out as text
end run

-- listIdFor returns the id of the Things3 list with the given short name. Ids
-- rather than names keep the script working in any language.
on listIdFor(listName)
	if listName is "inbox" then return "TMInboxListSource"
	if listName is "today" then return "TMTodayListSource"
	if listName is "upcoming" then return "TMCalendarListSource"
	if listName is "anytime" then return "TMNextListSource"
	if listName is "someday" then return "TMSomedayListSource"
	if listName is "logbook" then return "TMLogbookListSource"
	error "list-todos.applescript: unknown list " & listName & "; use inbox, today, upcoming, anytime, someday or logbook"
end listIdFor

-- todoLine returns one to-do as a tab-separated line.
on todoLine(todo)
	tell application "Things3"
		set projectName to ""
		if project of todo is not missing value then set projectName to name of project of todo
		set areaName to ""
		if area of todo is not missing value then set areaName to name of area of todo
		return id of todo & tab & name of todo & tab & ¬
			my isoDate(activation date of todo) & tab & ¬
			my isoDate(due date of todo) & tab & ¬
			projectName & tab & areaName & tab & tag names of todo
	end tell
end todoLine

-- isoDate returns a date as YYYY-MM-DD, or "" for missing value.
on isoDate(theDate)
	if theDate is missing value then return ""
	set y to year of theDate as integer
	set m to month of theDate as integer
	set d to day of theDate
	return (y as text) & "-" & text -2 thru -1 of ("0" & m) & "-" & text -2 thru -1 of ("0" & d)
end isoDate
