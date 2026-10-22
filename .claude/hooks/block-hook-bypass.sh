#!/usr/bin/env bash
# PreToolUse (Bash) hook: blocks a shell command that skips the git hooks in .githooks, which keep secrets out of
# commits and pushes with bin/leaks: --no-verify, `git commit -n`, and anything that sets or overrides
# core.hooksPath. When a git hook stops a commit, fix what it reports.
#
# stdin: the hook's JSON, with .tool_input.command. Exit 2 blocks the command and tells the agent why.
set -euo pipefail

command=$(jq -r '.tool_input.command // empty')

if grep -qE -- '--no-verify' <<<"$command"; then
  reason="--no-verify skips them"
elif grep -qiE -- 'hookspath' <<<"$command"; then
  reason="core.hooksPath decides whether they run"
elif grep -qE -- '(^|[^[:alnum:]_.-])git[[:space:]][^;&|]*commit[^;&|]*[[:space:]]-[[:alpha:]]*n[[:alpha:]]*([[:space:]]|$)' \
  <<<"$command"; then
  reason="git commit -n skips them"
else
  exit 0
fi

echo "Blocked: this command skips the git hooks that keep secrets out of commits and pushes ($reason). Fix what" \
  "bin/leaks reports instead. A finding that isn't a secret gets \`betterleaks:allow\` in a comment on its line, or" \
  "its fingerprint in .betterleaksignore with the reason." >&2
exit 2
