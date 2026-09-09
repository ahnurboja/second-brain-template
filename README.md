# Second Brain

A personal knowledge base made of plain Markdown files, maintained by [Claude Code](https://claude.com/claude-code) and browsable in [Obsidian](https://obsidian.md).

This repo is the **template**: the folder structure, the conventions Claude follows, and the machine setup that lives outside the vault. It contains no notes — clone it, run the installer, and start capturing.

## The idea

Most note systems fail because writing notes is work and finding them later is more work. This one inverts the effort: **Claude is the primary author.** You have a conversation; Claude decides what was worth keeping, writes it as a linked note, and searches those notes before answering you next time. You read and browse.

That's the **LLM-Wiki pattern**. Three rules make it work:

- **Search before answering.** Every session, in every repo, Claude looks here first and cites what it finds — so a thing you explained once doesn't get re-derived from scratch a month later.
- **Capture what isn't discoverable.** The bar is *"could Claude have found this anywhere other than by being told?"* Decisions and their rationale, solved problems and their diagnosis, your preferences and setup, the people around you. Not routine operations, not anything already in the code.
- **Link aggressively.** Any concept that could have its own note gets `[[wrapped]]`. The value compounds — each new note makes the existing ones more findable.

There's no `index.md` and no `log.md`. Git history is the audit trail; `git log` and `grep` are the navigation.

## What's in here

```
.
├── .claude/
│   ├── CLAUDE.md              # The conventions Claude follows inside the vault
│   └── rules/
│       ├── capture.md         # When and how to capture — injected into EVERY session
│       └── todo.md            # How the TODO list is worked — injected into every session
├── .obsidian/                 # Obsidian vault config (plugins, graph colours)
├── setup/
│   ├── install.sh             # Wires the vault into Claude Code
│   ├── settings.snippet.json  # What install.sh merges, if you'd rather do it by hand
│   ├── global-claude-md-snippet.md  # Section to paste into ~/.claude/CLAUDE.md
│   └── hooks/
│       └── second-brain-autocommit.sh  # SessionEnd: commits and pushes your notes
├── TODO.md                    # Running task list, with a Reminders section
├── career/  people/  projects/  research/  topics/  travel/
└── README.md
```

## Setup

### Prerequisites

- [Claude Code](https://claude.com/claude-code)
- `git`, `jq` (`brew install jq`)
- [Obsidian](https://obsidian.md) — optional; the notes are plain Markdown and read fine in any editor

### 1. Clone it as your vault

```bash
git clone https://github.com/YOUR-USERNAME/second-brain-template.git ~/second-brain
cd ~/second-brain
rm -rf .git && git init && git add -A && git commit -m "Initial vault"
```

The `rm -rf .git` matters: you want your own history, not the template's, and you do **not** want to accidentally push personal notes back to the template's remote.

Then create your own **private** repo and point at it:

```bash
gh repo create second-brain --private --source=. --remote=origin --push
```

> Keep it private. Even with the privacy rules in `.claude/CLAUDE.md`, this fills up with your decisions, your finances, your people. Treat it like a journal.

### 2. Wire it into Claude Code

```bash
./setup/install.sh
```

That does two things:

- copies `second-brain-autocommit.sh` into `~/.claude/hooks/`
- merges the second-brain permissions and hooks into `~/.claude/settings.json` (backing up the old one first)

It's safe to re-run — it detects entries it already added and leaves them alone. `DRY_RUN=1 ./setup/install.sh` prints the merged settings without writing. A vault somewhere other than `~/second-brain` works too: `VAULT=~/notes ./setup/install.sh`.

To do it by hand instead, merge `setup/settings.snippet.json` into `~/.claude/settings.json` yourself (replacing `/Users/YOU` with your home directory) and copy the hook across.

### 3. Add the global instruction

Paste the section from [`setup/global-claude-md-snippet.md`](setup/global-claude-md-snippet.md) into your global `~/.claude/CLAUDE.md`.

This is the step people skip, and it's the one that makes the system work outside the vault. Without it Claude still loads the capture rules, but nothing tells it to *search the second-brain before answering* while you're deep in some unrelated repo.

### 4. Open it in Obsidian (optional)

Obsidian → *Open folder as vault* → `~/second-brain`. The `.obsidian/` config here turns on backlinks, the graph, the tag pane, and colours the graph by folder. Obsidian's own local state (`workspace.json`) is gitignored.

### 5. Restart Claude Code

Hooks load at session start. Open a new session and check the top of it: you should see the date, the capture rules, and your TODO list injected.

## How the pieces fit

Three layers, each doing one job:

| Layer | Lives in | Loaded when | Job |
|---|---|---|---|
| Global instruction | `~/.claude/CLAUDE.md` | Every session | Tells Claude the second-brain exists and to search it first |
| Hook-injected rules | `<vault>/.claude/rules/*.md` | Every session, via SessionStart hook | The capture bar, the TODO workflow, plus your live TODO list |
| Vault conventions | `<vault>/.claude/CLAUDE.md` | Sessions started inside the vault | Full note types, frontmatter, folder rules, privacy policy |

Plus one hook at the other end: **SessionEnd autocommit**. When a session ends, if the vault has uncommitted changes, a Claude Haiku one-shot writes a commit subject from the diff and the script commits and pushes. You never think about committing notes.

```
                    ┌──────────────────────────────────────┐
   SessionStart ───►│  date + capture.md + todo.md + TODO  │
                    └──────────────────────────────────────┘
                                     │
                        ... your session happens ...
                                     │
                    ┌──────────────────────────────────────┐
   SessionEnd   ───►│  diff → Haiku writes subject → push  │
                    └──────────────────────────────────────┘
```

Test the autocommit hook without it committing anything:

```bash
SECOND_BRAIN_AUTOCOMMIT_DRY_RUN=1 ~/.claude/hooks/second-brain-autocommit.sh
```

## The folders

| Folder | For |
|---|---|
| `topics/` | Permanent notes — concepts, sources, MOCs, decisions. The bulk of the vault. |
| `people/` | Individuals, and named groups (a friend group, a team). |
| `projects/` | Ongoing work — *doing* something. Goals, status, decisions. |
| `research/` | Investigating a question. Projects link to research rather than embedding it. |
| `career/` | Job, employer, team, work tech. |
| `travel/` | Travel logs, one folder per year. |

Rename or drop any of them — just update the folder table at the bottom of `.claude/CLAUDE.md` to match, since that's what Claude files new notes against.

## A note on other people's privacy

`.claude/CLAUDE.md` carries a privacy policy for `people/` notes, and it's the part worth reading before you start. In short: every person note is tagged `close` or `contact`; close people get contact details, relation, birthday, and shared context and *nothing else* — no personal details, opinions, or struggles, even if they come up in conversation. Claude asks before writing any note about anyone but you.

Notes about other people are the part of a system like this that can actually hurt someone. The default is deliberately conservative; loosen it knowingly if you loosen it at all.

## Using it

Mostly you don't do anything — you talk to Claude and the notes accumulate. What's worth knowing:

- **Ask it things.** "What did I decide about X?" searches the notes before answering.
- **`TODO.md` is live.** Tasks get added as they surface in conversation and ticked off in place. The `## Reminders` section at the top is raised at the start of every session, and a reminder can be gated — `- [ ] (from 2026-03-01) Ask how the trial went` stays invisible until that date.
- **Commit history is the index.** `git log --oneline` reads as a log of what you learned and when.
- **Prune.** Claude proposes; you delete. Nothing here is precious.

## Customizing

- **Your name.** `.claude/CLAUDE.md` and the rules files say "the user" — swap in your name so Claude addresses you directly.
- **The capture bar.** Too many notes, or too few? `capture.md` is where the threshold lives.
- **Autocommit model.** `MODEL` at the top of `second-brain-autocommit.sh` — Haiku is used because it's cheap and a commit subject is an easy job.
- **Turn autocommit off.** Delete the `SessionEnd` block from `~/.claude/settings.json`. Everything else keeps working; you just commit by hand.

## Removing it

```bash
rm ~/.claude/hooks/second-brain-autocommit.sh
```

Then delete the second-brain `permissions.allow` entries and the `SessionStart`/`SessionEnd` blocks from `~/.claude/settings.json`, and the Second Brain section from `~/.claude/CLAUDE.md`. Your notes are just Markdown files and stay readable with or without any of this.

## Acknowledgments

Built with [Obsidian](https://obsidian.md) and [Claude Code](https://claude.com/claude-code). The LLM-Wiki pattern this follows was popularized by [Andrej Karpathy](https://github.com/karpathy).
