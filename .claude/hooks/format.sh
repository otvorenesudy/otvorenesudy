#!/usr/bin/env bash
# PostToolUse (Write|Edit|MultiEdit) hook: formats and lints the file the agent just wrote with `bin/lint --fix`, from
# the checkout the file is in: the main one, or a worktree under .claude/worktrees. What bin/lint can't fix goes back
# to the agent on stderr with exit 2. bin/lint passes over the kinds of files it doesn't check.
#
# stdin: the hook's JSON, with .tool_input.file_path
set -uo pipefail

root=$(cd "${CLAUDE_PROJECT_DIR:-.}" && pwd -P)
file=$(jq -r '.tool_input.file_path // empty')
[[ -n "$file" ]] || exit 0
[[ "$file" == /* ]] || file="$root/$file"
[[ -f "$file" ]] || exit 0
# Compare physical paths: the same directory can be reached through a symlink (macOS /var is /private/var).
file="$(cd "$(dirname "$file")" && pwd -P)/$(basename "$file")"
[[ "$file" == "$root"/* ]] || exit 0

# The checkout: the nearest directory above the file with a bin/lint.
checkout=$(dirname "$file")
until [[ -x "$checkout/bin/lint" || "$checkout" == "$root" || "$checkout" == / ]]; do
  checkout=$(dirname "$checkout")
done
[[ -x "$checkout/bin/lint" ]] || exit 0

if ! output=$(cd "$checkout" && bin/lint --fix "$file" 2>&1); then
  printf '%s\n' "$output" >&2
  exit 2
fi
