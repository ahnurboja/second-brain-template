#!/usr/bin/env bash
#
# SessionEnd hook: commit and push uncommitted changes in the second-brain vault.
#
# When the vault has changes, a Claude Haiku one-shot writes a <=60-char commit
# subject from the diff, then this script commits (with a Claude attribution
# trailer) and pushes. Runs for every Claude Code session, but only ever touches
# the hardcoded vault path below.
#
# Set SECOND_BRAIN_AUTOCOMMIT_DRY_RUN=1 to print what it would do without
# staging, committing, or pushing.

set -uo pipefail

VAULT="${SECOND_BRAIN_AUTOCOMMIT_VAULT:-$HOME/second-brain}"
MODEL="claude-haiku-4-5-20251001"
FALLBACK_SUBJECT="Update vault notes"
GEN_TIMEOUT=90

# Recursion guard. The subject-line step below spawns a nested `claude -p`, and a
# headless run still fires SessionEnd hooks. Two things stop the loop: this
# exported flag (inherited by the nested run and its hooks, so a re-entry exits
# here), and `--setting-sources project` on the nested call (the vault has no
# project hooks, so the autocommit hook never fires in the first place).
[ -n "${SECOND_BRAIN_AUTOCOMMIT:-}" ] && exit 0
export SECOND_BRAIN_AUTOCOMMIT=1

DRY_RUN="${SECOND_BRAIN_AUTOCOMMIT_DRY_RUN:-}"

cd "$VAULT" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Nothing tracked-but-modified and nothing untracked -> nothing to do.
if git diff --quiet && git diff --cached --quiet && [ -z "$(git status --porcelain)" ]; then
  exit 0
fi

# Compact view of the change for the model, without touching the index: status,
# a diffstat of tracked edits, then the tracked diff followed by the full text of
# any new notes.
CHANGE_SUMMARY="$(
  git status --porcelain
  echo
  git diff HEAD --stat
  echo
  {
    git diff HEAD --unified=0
    git ls-files --others --exclude-standard -z | while IFS= read -r -d '' f; do
      printf '\n=== new file: %s ===\n' "$f"
      cat -- "$f"
    done
  } | head -c 12000
)"

read -r -d '' PROMPT <<EOF || true
Write ONE git commit subject line for these changes to a personal Markdown
notes vault (an Obsidian "second brain").

Requirements:
- Output ONLY the subject line. No quotes, no backticks, no code fences, no
  trailing period, no explanation.
- Imperative mood: "Add", "Update", "Rename", "Remove", "Link".
- At most 60 characters.
- Summarize the substance of the note changes. Name the note(s) when only one
  or two changed; describe the theme when more changed.

Changes:
$CHANGE_SUMMARY
EOF

RAW_SUBJECT="$(
  printf '%s' "$PROMPT" \
    | timeout "$GEN_TIMEOUT" claude -p --model "$MODEL" --strict-mcp-config --setting-sources project 2>/dev/null \
    | head -n1 | tr -d '\r'
)"

# Strip surrounding whitespace and stray wrapping quotes/backticks.
SUBJECT="$(
  printf '%s' "$RAW_SUBJECT" \
    | sed -E 's/^[[:space:]]*["'"'"'`]?//; s/["'"'"'`]?[[:space:]]*$//'
)"

[ -z "$SUBJECT" ] && SUBJECT="$FALLBACK_SUBJECT"
SUBJECT="$(printf '%s' "$SUBJECT" | cut -c1-60)"

BODY="Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
Claude-Session: second-brain-autocommit hook"

if [ -n "$DRY_RUN" ]; then
  echo "[second-brain-autocommit] would commit with subject:"
  echo "  $SUBJECT"
  echo "[second-brain-autocommit] files:"
  git status --porcelain | sed 's/^/  /'
  exit 0
fi

git add -A
git commit --quiet -m "$SUBJECT" -m "$BODY" || exit 0
git push --quiet 2>/dev/null || git push 2>&1 | tail -n2
