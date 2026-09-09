<!--
Paste this section into your global ~/.claude/CLAUDE.md.

It is what makes Claude reach for the second-brain in sessions that have
nothing to do with the vault — a coding session in another repo, a question
about a restaurant, anything. Without it, the hook-injected capture rules
still load, but Claude has no standing instruction to search before
answering.
-->

## Second Brain

A personal knowledge base lives at `~/second-brain/` — plain Markdown files for capturing reusable knowledge across sessions. Capture rules are injected automatically at session start via a SessionStart hook.

**Call it the second-brain, never "the vault."** It's just files on disk; Obsidian is one way to view them, VS Code is another. The tool isn't the thing.

**When to use it:** Search the second-brain before answering from general knowledge. Write notes when you learn something the user would otherwise have to repeat in a future session.

**How it works:** The second-brain's `CLAUDE.md` has full querying and writing conventions. The hook-injected `capture.md` rules cover the essentials for sessions outside it.

### TODO workflow

`~/second-brain/TODO.md` is a running personal task list — checkboxes, any kind of task, not just project work. It's a working part of every session:

- **Add proactively.** When an actionable task surfaces — stated directly, or falling out as a side effect of other work — add it as a `- [ ] ...` line. Keep it to one short sentence; put any real detail in its own note and link it with `[[wikilink]]`.
- **Check it during relevant work.** At the start of a task, glance at TODO.md for open items related to what's being worked on.
- **Close the loop.** Mark items `- [x]` in place when done, rather than deleting them.

Full rules: `~/second-brain/.claude/rules/todo.md` (hook-injected at session start, same as `capture.md`).
