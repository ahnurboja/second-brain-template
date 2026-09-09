#!/usr/bin/env bash
#
# Wire this second-brain into Claude Code.
#
# Installs the SessionEnd autocommit hook and merges the second-brain entries
# into ~/.claude/settings.json (permissions + SessionStart/SessionEnd hooks).
# Safe to re-run: existing second-brain entries are detected and left alone.
#
# Usage:
#   ./setup/install.sh              # vault is ~/second-brain
#   VAULT=~/notes ./setup/install.sh
#
# Set DRY_RUN=1 to print the merged settings without writing anything.

set -euo pipefail

VAULT="${VAULT:-$HOME/second-brain}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOKS_DIR="$CLAUDE_DIR/hooks"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN="${DRY_RUN:-}"

command -v jq >/dev/null || { echo "error: jq is required (brew install jq)" >&2; exit 1; }

VAULT="${VAULT/#\~/$HOME}"
[ -d "$VAULT" ] || { echo "error: no vault at $VAULT — clone it there first, or set VAULT=" >&2; exit 1; }
[ -f "$VAULT/.claude/rules/capture.md" ] || { echo "error: $VAULT doesn't look like a second-brain (no .claude/rules/capture.md)" >&2; exit 1; }

# 1. The autocommit hook.
mkdir -p "$HOOKS_DIR"
if [ -z "$DRY_RUN" ]; then
  install -m 755 "$SCRIPT_DIR/hooks/second-brain-autocommit.sh" "$HOOKS_DIR/second-brain-autocommit.sh"
  echo "installed $HOOKS_DIR/second-brain-autocommit.sh"
fi

# 2. settings.json. Absolute paths for the permission rules, ~ for the hook
# commands (they run through a shell, and stay portable across machines).
mkdir -p "$CLAUDE_DIR"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

SESSION_START_CMD="date '+Current date and time: %Y-%m-%d %H:%M (%A)'; cat $VAULT/.claude/rules/capture.md $VAULT/.claude/rules/todo.md $VAULT/TODO.md 2>/dev/null || true"

MERGED="$(
  jq \
    --arg vault "$VAULT" \
    --arg hook "$HOOKS_DIR/second-brain-autocommit.sh" \
    --arg start_cmd "$SESSION_START_CMD" '
    def has_sb($path; $needle):
      [getpath($path) // [] | .[]? | .hooks[]? | .command // ""]
      | any(contains($needle));

    .permissions.allow = (
      (.permissions.allow // []) + [
        "Read(//" + ($vault | ltrimstr("/")) + "/**)",
        "Edit(//" + ($vault | ltrimstr("/")) + "/**)",
        "Bash(git -C " + $vault + " *)",
        "Bash(cd " + $vault + " && git *)"
      ] | unique
    )
    | if has_sb(["hooks","SessionStart"]; "/.claude/rules/capture.md") then .
      else .hooks.SessionStart = ((.hooks.SessionStart // []) + [{
        matcher: "",
        hooks: [{ type: "command", command: $start_cmd }]
      }]) end
    | if has_sb(["hooks","SessionEnd"]; "second-brain-autocommit.sh") then .
      else .hooks.SessionEnd = ((.hooks.SessionEnd // []) + [{
        matcher: "",
        hooks: [{
          type: "command",
          command: $hook,
          timeout: 120,
          statusMessage: "Auto-committing second-brain notes"
        }]
      }]) end
  ' "$SETTINGS"
)"

if [ -n "$DRY_RUN" ]; then
  echo "--- would write $SETTINGS ---"
  printf '%s\n' "$MERGED"
  exit 0
fi

cp "$SETTINGS" "$SETTINGS.bak.$(date +%Y%m%d%H%M%S)"
printf '%s\n' "$MERGED" > "$SETTINGS"
echo "updated $SETTINGS (previous version saved alongside as .bak.*)"

cat <<EOF

One manual step left: paste the section from
  $SCRIPT_DIR/global-claude-md-snippet.md
into $CLAUDE_DIR/CLAUDE.md, so Claude reaches for the second-brain in sessions
outside the vault. Then start a new Claude Code session to load the hooks.
EOF
