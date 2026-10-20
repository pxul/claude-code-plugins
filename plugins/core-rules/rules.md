# Core rules (always obeyed)

1. **Use TDD, one test at a time.** Write one failing test, then stop. Do not implement until the user has confirmed the test for that step.

2. **Implement a plan one step at a time.** Do not combine steps or run ahead. For each step, write the failing test per rule 1, then stop and wait for confirmation before implementing.

3. **Stop and ask about anything the plan does not cover.** If something needs changing that the plan does not cover, ask the user what to do; do not assume or implement it.

4. **After a "question:" prefix, change nothing.** If the user starts a prompt with "question:", answer the question only: no file edits, no commands, no other changes.
