# CLAUDE.md — Second Brain

This is a Markdown knowledge base (a "second brain"), viewable as an Obsidian vault. It follows the **LLM-Wiki pattern**: Claude Code is the primary author and maintainer — writing, linking, and curating notes — while the user primarily reads and browses.

> Personalize this file. Everywhere it says "the user", you can substitute your own name so Claude addresses you directly, and the examples below can be swapped for ones from your own life.

## Conventions

- Files are Markdown following Obsidian conventions: wikilinks (`[[note-name]]`), YAML frontmatter, and `#tags`.
- The `.obsidian/` directory is vault configuration — don't modify unless asked.
- Keep notes atomic: one idea or topic per file.
- Prefer linking over duplicating — connect notes with `[[wikilinks]]` rather than restating content.

## Note types

There's no template scaffolding — write notes freeform following the frontmatter and structure conventions below.

| Type | Use for |
|---|---|
| Concept | Atomic Zettelkasten note — one idea, clearly explained. The default type for ~70% of notes. |
| Source | Ingested article, book, talk, or significant conversation. Extracts key ideas and preserves verbatim quotes. |
| Map of Content (MOC) | Hub page linking related notes. Create automatically when a topic accumulates 4+ concept notes. |
| Person | Context about someone — role, expertise, shared projects. |
| Decision | Record of a decision with context, options, rationale, and consequences. |
| Project | Ongoing work — *doing* or achieving something — goals, status, key decisions, people involved. Lives in `projects/`. |
| Research | Investigating a question to find answers — open questions, candidate approaches, findings. Not a project itself; one or more projects reference it via `[[wikilink]]` rather than duplicating it. If multiple projects draw on the same research, they all link to the one research note. Lives in `research/`. |

## The `## For future Claude` convention

Every note MUST include a `## For future Claude` heading near the top with a 2-3 sentence plain-English summary. This is the most important section of any note. When searching the vault for relevance to a query, read this section first — it tells you whether the full note is worth reading. When writing a new note, invest care in this section: imagine you're a future Claude scanning 50 notes in 10 seconds, and make yours stand out if it's relevant.

## People notes & privacy policy

Person notes are about people in the user's life, not by them — treat other people's privacy as a hard constraint, not a style choice.

- **Every person note about someone other than the user must carry a closeness tag**: `close` (friends, family, anyone personally close to them) or `contact` (everyone else — colleagues, acquaintances, service providers, etc.). Put it in the `tags` list, e.g. `tags: [person, close]`. The user's own note uses `tags: [person, me]` and this policy doesn't apply to it — their own life is fair game to document fully.
- **For `close` people**: only capture what's useful for keeping in touch or context — name, email/contact info, relation to the user, birthday, and shared context (e.g. "college roommate," "sister," "plays tennis on Sundays"). A **birthday is fine to record, and include the year** (e.g. `Birthday: 9 September 1999`) — it's a stable fact, and age can be derived from it when actually needed. Do NOT record their **age** as such — it goes stale and needs maintenance. Do NOT record personal life details, opinions, struggles, or other private information, even if the user mentions it in passing — that's their story to tell, not the user's to archive. If something like that comes up, don't write it down.
- **For `contact` people**: more latitude — role, organization, how the user knows them, other useful working context — but nothing sensitive (health, finances, relationship status, etc.) unless the user explicitly says to record it.
- **Always ask before saving personal info about someone else**, regardless of closeness tier. Show what you're about to write and get a yes before creating or updating a person note about anyone but the user. This is a standing rule, not a one-time check.
- If unsure whether a person is `close` or `contact`, ask rather than guess.
- **Cross-link people who share a group or context.** When two or more people notes are connected — same friend group, same work team, same trip, etc. — link them to each other's `Shared context` section, not just each to the user. If a named group exists (a friend-group nickname, say) or a team has its own note, link every member to that group/team note too, and list members there. When adding a new person who belongs to an existing group/team, update the other members' notes (and the group note) to include them — don't leave the link one-directional. Don't assume a relationship between two people that hasn't been stated — link only what the user has actually confirmed, and ask if it's unclear.

## Frontmatter

Every note starts with YAML frontmatter. Minimum universal fields:

```yaml
title: "Note Title"
date: YYYY-MM-DD
type: concept | source | moc | person | decision | project | research
status: draft | evergreen | archived
tags: []
```

Type-specific additions:

- **Concept:** `confidence` (stated | high | medium | speculation), `source` (optional wikilink)
- **Source:** `source_type` (article | book | talk | conversation | video), `source_url`, `source_author`, `date_accessed`
- **Person:** `role`, `organization`
- **Decision:** `decision_date`

### Note status lifecycle

```
draft → evergreen → archived
  ↑
stub (placeholder for a note that should exist but hasn't been written yet)
```

- **draft** — default for new notes. Content exists but may be incomplete or lightly linked.
- **evergreen** — stable, well-linked, actively maintained. Promote when the note feels solid.
- **archived** — outdated but kept for history. Remove from active index sections.
- **stub** — placeholder created by a wikilink to a note that doesn't exist yet. Replace with a draft when possible.

## Workflows

### Ingest

When the user shares an article, book, talk, or has a substantive conversation:

1. Create a source note (`type: source`) in `topics/`
2. Extract key ideas and verbatim quotes
3. For each key idea worth keeping, create a concept note (`type: concept`)
4. Link the concept notes back to the source

### Synthesize

When multiple notes converge on a topic (4+ concept notes):

1. Create a Map of Content (`type: moc`) in `topics/`
2. Link all related notes under it
3. Add backlinks from the concept notes to the MOC

### Link

Every time you write a note:

1. Add 3-7 `[[wikilinks]]` to related notes
2. Create stubs for linked notes that don't exist yet
3. Add backlinks from existing notes to the new one (update their Connections/Related sections)

### Lint

Periodically (at least every few sessions, or when asked):

1. Check for broken wikilinks — notes linked but not created (stubs without content)
2. Check for orphan notes — notes with no incoming links
3. Check for stale frontmatter — missing `title`, `date`, `type`, or `status`

## Version control

This vault is a git repo. There's no index.md or log.md — git commit history is the navigation map and audit trail instead:

- **Discover notes** with `git ls-files`, `find`, or `grep` rather than a hand-maintained index.
- **Commit after creating or significantly updating a note.** One commit per logical unit of capture (a note, or a small set of tightly related notes). Write commit messages the way `log.md` entries used to read: `create: docker-networking — VPN DNS failure and the fallback fix`.
- **Never rewrite history** (`commit --amend`, `rebase`, force-push) — the whole point is an honest, append-only trail. Fix mistakes with a new commit.
- **Push after committing** so the remote stays current, unless the user says otherwise.

## Querying rule

When the user asks a question, asks you to recall something, or wants to find information:

1. **Search first.** Always search the vault before answering from your own knowledge. Use `grep` for full-text search across notes, and `ls` or `find` for browsing the file tree.
2. **Surface what's there.** If relevant notes exist, read them and answer from them. Quote or paraphrase the vault's content — don't replace it with your own version.
3. **Cite your sources.** When you reference a note, link to it as a path (e.g., `topics/learning.md`) so the user can open it in Obsidian.
4. **Map connections.** When answering, point out related notes the user might not have thought of — suggest `[[wikilinks]]` they could add for future discovery.
5. **Gap check.** If the vault has partial or contradictory information on the question, say so. Offer to update the note or create a new one — but ask first, don't write until the user says yes.
6. **Fall back gracefully.** If nothing relevant exists, say so plainly, then answer from your own knowledge. Offer to capture the answer as a new note.

## Writing rule

When the user asks you to create a note, capture something, or write down an idea:

1. **One idea, one file.** Don't stuff multiple topics into one note. If the user gives you a brain dump, split it into atomic notes and link them.
2. **Frontmatter first.** Every note starts with YAML frontmatter with the correct fields for its type (see Frontmatter above).
3. **Filename = title.** Use the title as the filename in kebab-case (e.g., `learning-principles.md`). No dates in filenames unless inherently temporal. **Exception: person notes** — filename is the title Title Cased with hyphens for spaces (e.g., `Mum.md`, `Sam-Rivera.md`), not lowercase kebab-case. Prefer just the first name / how the user refers to them unless a full name is needed to disambiguate. **Exception: travel-log notes** (`travel/<year>/`) — filename/title is just the place, Title Cased, no year suffix (the year folder already disambiguates) and no country (e.g. `Lisbon.md`, not `Lisbon-Portugal.md` — put the country in the note body instead). If a trip spans multiple places, a short list in the name is fine (e.g. `New-York-Toronto.md`) — only reach for a single covering name (e.g. `Southeast-Asia.md`) if the list would otherwise get long or unwieldy. Either way, list the actual cities/countries in the note body.
4. **Link generously.** Every time you mention a concept that has (or should have) its own note, wrap it in `[[wikilinks]]`. A note with no links is a dead end.
5. **Place carefully.** Put the file where it belongs:
   - Permanent notes (concepts, MOCs, sources, decisions) → `topics/`
   - Person notes → `people/`. Also covers named groups of people (a friend-group
     nickname, a team) — not just individuals.
   - Project notes (doing/achieving something) → `projects/`
   - Research notes (studying a question, finding answers) → `research/`; have the
     relevant project(s) link to it rather than embedding the research inline
   - Career notes (the user's job, employer, team, work projects/tech) → `career/`
   - Travel logs → `travel/<year>/`
6. **Keep it tight.** Notes are for the user's future self. Write in complete sentences but be concise. Prefer plain language over jargon. Use headings for scannability, bullet points for lists, and blockquotes for highlights.
7. **Level up the network.** After writing, look at related existing notes. Suggest adding backlinks from them to the new note. A well-linked vault gets more valuable over time.
8. **Confirm before overhauling.** Creating a new note is cheap — ask permission before restructuring folders or refactoring many existing notes.

## Folder reference

| Folder | Purpose |
|---|---|
| `topics/` | Permanent notes — concepts, sources, MOCs, decisions. The main content of the vault. |
| `people/` | Person notes — context about individuals, and named groups of people (friend groups, teams). |
| `projects/` | Project notes — ongoing work, goals, status, key decisions. |
| `research/` | Research notes — investigating a question, not doing/building. Referenced by the project(s) that need the answer; shared research is linked from multiple projects rather than duplicated. |
| `career/` | Notes about the user's job — employer, team, work projects, tech stack. |
| `travel/` | Travel logs, one folder per year. |
