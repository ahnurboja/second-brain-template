# TODO Rules

`~/second-brain/TODO.md` is the user's personal task list — any task, not just project work. Treat it as a working part of every session, not something only touched when directly asked.

## Reminders — act on these first

TODO.md has a `## Reminders` section at the top, and its contents are injected into every session by the SessionStart hook.

- **Respect a reminder's constraint.** A reminder may open with a constraint in parentheses; the session start also injects the current date and time, so compare against that.
  - `(from YYYY-MM-DD)` / `(from YYYY-MM-DD HH:MM)` — don't raise it before then. This is the main form: use it whenever the reminder only makes sense after something has happened.
  - Anything else in the parentheses is a plain-English condition (`(only when at the PC)`) — judge it, and stay silent when it clearly isn't met.
  - A constrained reminder that isn't ready yet is invisible: don't mention it, don't announce that it's waiting.
- **Handle them at the start of every session, before the thing the user actually asked for.** A reminder is there precisely because it would otherwise never come up on its own — waiting for a relevant moment defeats the point.
- Keep it short: raise each open reminder in a line or two (usually a question), then move on to the real request. Don't let them derail the session.
- Raise each one **once per session**. If the user doesn't engage, drop it and carry on — don't re-ask later in the same session.
- When a reminder is answered, act on the answer (write the note, log the entry), then mark it `- [x]` or delete it if it was a one-off. Recurring reminders stay.
- Keep the section short. A reminder that has gone unanswered across many sessions is one the user doesn't want — ask whether to drop it rather than repeating it forever.

## Adding tasks

- When a task surfaces in conversation — something the user says they need to do, or an actionable follow-up falls out of other work — add it to TODO.md as a new `- [ ] ...` line. Don't wait to be told to write it down.
- TODO.md is grouped into `##` sections by project or category. Put a new task under the section it belongs to; if nothing fits, add a new section rather than dropping it at the end.
- Keep each line to one short sentence. If it needs supporting detail, context, or history, put that in its own note and link to it with `[[wikilink]]` rather than expanding inline.
- If the addition is a side effect of other work rather than something the user directly asked to track, mention that you added it rather than adding it silently.

## Addressing tasks

- At the start of relevant work, check TODO.md for open items related to what's being worked on and surface them.
- When a task is completed, mark it `- [x]` in place rather than deleting the line — keeps a record.
- If checked-off items accumulate and clutter the active list, ask before archiving or removing them.

## Linking

- Any non-trivial TODO should link to the note that holds its context (project note, decision note, etc.). A bare TODO with no link and no obvious one-line meaning is a sign it needs its own note first.
