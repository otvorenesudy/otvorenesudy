---
name: conventional-commit
description: Use when committing changes or writing a pull request title. Writes Conventional Commits messages (type, optional scope, imperative summary, optional body and footer) and commits only the files that belong to the change.
argument-hint: '[type] [scope]'
---

# Conventional Commits

Every commit message and pull request title follows [Conventional Commits 1.0](https://www.conventionalcommits.org/en/v1.0.0/).

## Steps

1. `git status` and `git diff` (or `git diff --cached`): see exactly what changed.
2. Stage only the files that belong to this change, by name: `git add <file> ...`. Never `git add -A` or `git add .`;
   they pick up local files that don't belong in the commit.
3. Write the message in the shape below and commit: `git commit -m "<type>(<scope>): <summary>" -m "<body>"`.
4. Check the result with `git log -1 --stat`.

## Shape

```
<type>(<scope>): <summary>

<body: why the change was needed and what it changes, wrapped at 72 columns>

<footer: BREAKING CHANGE: ..., Refs #123>
```

- **type**: `feat` (new behavior), `fix` (a bug), `refactor` (same behavior), `perf`, `test`, `docs`, `build`
  (dependencies, Gemfile, package.json), `ci`, `chore` (tooling, agent setup, data refreshes), `revert`.
- **scope** (optional): the area the change is confined to, such as `importer`, `api`, `search`, `deploy`.
- **summary**: imperative mood ("add", not "added"), lowercase, no trailing period, at most about 70 characters.
- **body** (optional): the reason and the effect, not a list of files. Leave it out when the summary says it all.
- **footer** (optional): `BREAKING CHANGE: <what breaks>`, or `!` after the type, for anything that breaks a caller;
  issue references.

## Examples

```
feat(importer): import criminal hearings from obcan.justice.sk
fix(search): keep the court facet when the query is empty
refactor: extract the judge name normalizer
build: bump nokogiri to 1.16.5
chore: refresh genpro.gov.sk office fixtures
feat(api)!: require an API key for /decrees/sync
```

One commit is one concern. Split unrelated changes into separate commits, and structural moves from behavior changes.
