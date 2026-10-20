---
name: morning-review
description: The daily review of a project's next-steps.md — ask what got done, move items up, carry over what was missed, re-date the file and commit it. Use when the session-start hook asks for it, or when the user asks for the morning review.
---

# Morning review

Brings `next-steps.md` up to today, in the layout the `project-planning` skill describes. Run it before other work when the session-start hook asks for it.

1. Read `next-steps.md` and its `Reviewed` date.
2. Ask the user what got done since that date. Never assume an item is done from the files or the git history; say what they suggest and ask the user to confirm.
3. Drop what is done.
4. Put anything planned for a day now past and not done under **Carried over**, with the date it was first due and the days carried, and update the count on items already there. Ask the user whether each gets a new day or is dropped.
5. Move items up as their day arrives: Tomorrow into Today, This week into Tomorrow, Next week into This week on a Monday, Later into its week. Give Today and Tomorrow their goals if the project has a time commitment.
6. Check **Waiting on** and **Ongoing** are still true.
7. Set the `Reviewed` line to today, with the weekday, and the dates in the Today and Tomorrow headings.
8. Commit `next-steps.md` on its own.
