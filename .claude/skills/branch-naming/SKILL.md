---
name: branch-naming
description: Use whenever creating, renaming or pushing a Git branch, including the claude/* branches of Claude Code on the web. Names the branch after the change with a Conventional Commits type and a 3–6 word kebab-case slug, and rejects placeholders like claude/changes or patch-1.
argument-hint: '[type] [short-description]'
---

# Branch Naming

A branch name is what a reviewer reads first in the pull request list and in CI notifications. Name it after the
change it carries, before `git switch -c`, `git worktree add -b`, `git push -u` or `gh pr create`.

## Steps

1. Say in one sentence what the branch does.
2. Pick its [Conventional Commits](https://www.conventionalcommits.org/) type: `feat`, `fix`, `refactor`, `perf`,
   `test`, `docs`, `build`, `ci`, `chore`.
3. Reduce the sentence to a kebab-case slug of 3–6 words that names the specific change.
4. Compose the name:
   - locally: `<type>/<slug>`, for example `fix/court-facet-empty-query`;
   - in Claude Code on the web (`CLAUDE_CODE_REMOTE=true`): `claude/<type>-<slug>`, for example
     `claude/fix-court-facet-empty-query`.
5. The pull request title describes the same change. If they drift apart, rename the branch.

## Never

`claude/changes`, `claude/update`, `claude/fix`, `claude/wip`, `claude/patch-1`, `fix/bug`, a date or an issue number
alone, or the user's prompt pasted in. If the change doesn't fit a 3–6 word slug, it isn't ready for a branch: finish
or split it first.

## Renaming

```bash
git branch -m <new-name>
git push -u origin <new-name>
git push origin --delete <old-name>     # only when no pull request is open against it
```

GitHub can't move an open pull request to another branch. With one already open, push the new branch, open a pull
request from it (`gh pr create`), and close the old one with a link to the new one.
