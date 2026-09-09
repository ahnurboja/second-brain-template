# Second Brain — Capture Rules

You have access to a personal knowledge base at `~/second-brain/`, a Markdown vault. Capture reusable knowledge here so future sessions can search notes instead of re-deriving, re-researching, or asking the user again.

## When to capture

Write a note when you learn something that meets ANY of these criteria:

- **Personal context** — facts about the user not discoverable from code or docs (preferences, tools, projects, people, system setup)
- **Decisions & rationale** — a non-obvious choice was made and the *why* matters for future work
- **Solved problems** — a bug or config issue that took real effort to diagnose and fix; capture the diagnosis and solution
- **Mental models** — frameworks, workflows, or ways of thinking the user explains or employs

**Skip:** routine operations, transient debugging state, anything derivable from existing code or docs, conversation mechanics.

When in doubt, offer to capture and let the user decide.

## How to capture

1. Write to `~/second-brain/` as an atomic Markdown note with YAML frontmatter (`title`, `date`, `tags`)
2. Filename = title in kebab-case (e.g., `docker-networking.md`)
3. Link related concepts with `[[wikilinks]]`
4. Place in the folder that fits (`topics/`, `projects/`, `research/`, `people/`, `career/`)
5. After writing, check if existing notes should add backlinks to the new one

Full conventions are in the vault's CLAUDE.md: `~/second-brain/.claude/CLAUDE.md`

## Examples

✅ **Capture:** "The user manages macOS configuration with nix-darwin" → `topics/nix-darwin.md`
✅ **Capture:** "Chose JWT over session tokens because of the microservices architecture" → `topics/auth-flow-decision.md`
✅ **Capture:** "Docker DNS breaks when the VPN is on — fix is adding 8.8.8.8 as a fallback DNS" → `topics/docker-networking.md`
❌ **Skip:** "Ran `npm install` to fix a dependency issue"
❌ **Skip:** "The user asked me to write a function that sorts arrays"
