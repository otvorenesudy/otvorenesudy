#!/usr/bin/env bash
# PreToolUse (Write|Edit|MultiEdit|NotebookEdit) hook: runs `bin/leaks --stdin` on the text an agent is about to write,
# from the checkout the file is in (the main one, or a worktree under .claude/worktrees), so a secret never reaches a
# file and no file is created under a name that holds secrets. What bin/leaks finds goes back to the agent on stderr
# with exit 2, which stops the write. Files outside the project aren't checked.
#
# stdin: the hook's JSON, with .tool_input.file_path (.notebook_path for notebooks) and the new text: .content (Write),
# .new_string (Edit), .edits[].new_string (MultiEdit) or .new_source (NotebookEdit)
set -uo pipefail

input=$(cat)
root=$(cd "${CLAUDE_PROJECT_DIR:-.}" && pwd -P)
file=$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input")
[[ -n "$file" ]] || exit 0
[[ "$file" == /* ]] || file="$root/$file"

# Compare physical paths: the same directory can be reached through a symlink (macOS /var is /private/var). The file,
# and the directories above it, may not exist yet.
existing=$(dirname "$file")
rest=$(basename "$file")
until [[ -d "$existing" ]]; do
  rest="$(basename "$existing")/$rest"
  existing=$(dirname "$existing")
done
file="$(cd "$existing" && pwd -P)/$rest"
[[ "$file" == "$root"/* ]] || exit 0

# The checkout: the nearest directory above the file with a bin/leaks.
checkout=$(dirname "$file")
until [[ -x "$checkout/bin/leaks" || "$checkout" == "$root" || "$checkout" == / ]]; do
  checkout=$(dirname "$checkout")
done
[[ -x "$checkout/bin/leaks" ]] || exit 0

text=$(jq -r '
  [.tool_input.content, .tool_input.new_string, (.tool_input.edits // [] | .[].new_string), .tool_input.new_source]
  | map(select(type == "string")) | join("\n")
' <<<"$input")

if ! output=$(cd "$checkout" && printf '%s\n' "$text" | bin/leaks --stdin "${file#"$checkout"/}" 2>&1); then
  printf '%s\n' "$output" >&2
  exit 2
fi
