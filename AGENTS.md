# otvorenesudy: Agent Instructions

[Open Courts](https://otvorenesudy.sk) (Otvorené súdy), the public website of a project that makes data about the
Slovak judiciary usable: courts, judges, hearings, decrees, proceedings, judge selection procedures, statistics and
property declarations, with faceted search and e-mail subscriptions to searches. **Rails 3.2 on Ruby 2.3.8**,
PostgreSQL (pg_trgm, unaccent, pgvector), Elasticsearch 1.7 through the in-house `Probe` library on Tire, Sidekiq,
Memcached, CoffeeScript and Bootstrap 4. A migration to Rails 8 is planned separately; until then, write for these
versions (the `ruby` rule lists what that rules out).

| Repository | What It Is | How It Relates |
| --- | --- | --- |
| otvorenesudy-api | Importers and the JSON API | Writes courts, judges, hearings and decrees into this app's database, then enqueues `UpdateRepositoryJob` here to reindex them |
| otvorenesudy-data | Static datasets (CSV, JSON, judges' CVs) | Checked out here as the `data` submodule; `rake process:*` loads it |
| otvorenesudy-prokuratura | The prosecutors' website | Sibling app on the same server |
| otvorenesudy-server | Ansible provisioning of the production server | Runs this app: nginx, Passenger, PostgreSQL, Elasticsearch 1.7, Redis, Memcached |

## How We Work: Acceptance First

Every feature, behavior change and bug fix starts as an acceptance test. Use the `acceptance-first` skill before
writing code; this is the summary. Tooling, deployment, configuration and refactors that keep behavior get no new
tests: check them by running them and the suite.

1. **Scenarios first**: each scenario the user gave, verbatim, plus edge cases (no results; Slovak diacritics in a
   query; a facet with nothing selected; a judge at several courts; a record updated after it was indexed). A bug fix
   starts with the bug as scenario 1.
2. **An end-to-end spec per scenario, red first.** Run it and watch it fail on its assertion.
3. **Implement outside-in** until it passes. Unit specs only for logic with many branches (parsers, indicators).
4. **Done** means every scenario's spec passes and `bin/test` is green, with its output shown.

| Behavior | Tested Through | Where |
| --- | --- | --- |
| Pages and user flows: search, facets, details, subscriptions | Integration specs with Capybara | `spec/integration/` |
| Search, facets, suggestions, subscription percolation | The `spec/lib/probe/` shared examples, from each model's spec, against a real index | `spec/models/` |
| Parsing sources | Parser specs against saved pages | `spec/lib/<source>/` |
| Mail | Mailer specs | `spec/mailers/` |

Use real collaborators: our code, Rails, PostgreSQL and Elasticsearch. Fake only the source websites (saved pages),
mail delivery and the clock. Never skip, delete or loosen a failing spec to get green; if a spec is wrong, say which
scenario it contradicts.

## Commands

```bash
bin/test                     # lint, then every spec; must be green before you are done
bin/test spec/models/court_spec.rb:12   # lint, then those specs
bin/lint                     # syntax_tree and RuboCop on the files this branch changed
bin/lint --fix <file>        # format and autocorrect a file (the edit hook does this for you)
bundle exec rails server
bundle exec sidekiq -C config/sidekiq.yml
```

`bin/test` needs, on localhost:

- **PostgreSQL** with pg_trgm, unaccent and pgvector. It rebuilds `opencourts_test` from `db/structure.sql`, then
  applies the migrations the dump is missing and warns about them.
- **Elasticsearch 1.7** with inline Groovy scripting (`README.md`). Without it, `bin/test` warns and the specs that
  index or search fail with "Connection refused".

It holds a machine-wide lock, because otvorenesudy-api uses the same test database, and runs outside the Claude Code
sandbox, because the app reads `.env` and `config/configuration.yml` while it boots. Run specs through it rather than
`bundle exec rspec`, which the sandbox can't boot.

## Code Conventions

- **Engineering**: the `engineering` skill. Small reviewable changes, the simplest thing that works, match the
  surrounding code, production-ready only.
- **Naming**: the `naming` skill. Short names in small scopes; descriptive names for methods, parameters, fields
  and anything public; precise nouns and verbs, no filler words.
- **Names people read** (CI workflows, jobs and steps, headings, table columns, English UI labels): title case, the
  `title-case` skill. "Check Out Repository", not "Checkout repository".
- **Rules** in `.claude/rules/` load when you touch the files they cover: `ruby`, `rspec`, `database`, `deploy`.
  Follow them.
- **Formatting is automatic.** After every edit a hook runs `bin/lint --fix` on the file and sends back what it
  couldn't fix. Fix those; don't hand-format.

  | Files | Tools | Settings |
  | --- | --- | --- |
  | `*.rb`, `*.rake`, `Gemfile` | syntax_tree, then RuboCop's Lint and Security cops, both for Ruby 2.3 | `.streerc`, `.rubocop.yml` (120 columns, single quotes) |

  They run from their own bundle (`tools/lint`, Ruby 3.3, picked through asdf or rbenv), since they no longer run on
  Ruby 2.3. Most code predates them, so `bin/lint` checks the files a branch changes; RuboCop's older offenses are
  listed in `.rubocop_todo.yml`. CoffeeScript, SCSS and ERB have no formatter here.
- **Translations**: Slovak is the default locale, English the other; user-facing strings go through `t(...)` with
  keys in both.
- **Dependencies**: gems must still support Ruby 2.3 and Rails 3.2. Add with `bundle add` and commit
  `Gemfile.lock`.

## Secrets

These files hold credentials. Never read, print, copy or decrypt them, and don't ask to; when a change needs a
secret, ask the user to add it.

| File | What |
| --- | --- |
| `.env`, `.env.local` | dotenv settings: the database login, hCaptcha keys, the Skylight token |
| `config/configuration.yml` | The app's secrets: secret token, Devise key, mailer login, Sidekiq password, Rollbar and Bing keys. `config/configuration.yml.example` and `.travis` show its keys with placeholders and are fine to read |
| `config/initializers/secret_token.rb` | Reads the secret token from `Configuration`; its git history still holds the token it used to hard-code |

Claude Code denies them to its file tools (`permissions.deny`) and to sandboxed commands
(`sandbox.filesystem.denyRead`), and a hook blocks shell commands that name them. `config/database.yml` and
`config/skylight.yml` only refer to ENV, and are fine to read.

## Commits, Branches and Pull Requests

Nothing deploys automatically: a maintainer deploys with Capistrano. Changes still reach `main` through reviewed
pull requests.

1. **One worktree per change**, off the latest `main`, on a branch named with the `branch-naming` skill:

   ```bash
   git fetch origin
   git worktree add -b <type>/<short-description> .claude/worktrees/<short-description> origin/main
   git -C .claude/worktrees/<short-description> submodule update --init
   ```

   In Claude Code, switch the session into it with `EnterWorktree`.
2. **Commit** with the `conventional-commit` skill, staging files by name.
3. **Push and open a pull request** when the user asks: `git push -u origin <branch>`, then `gh pr create` with a
   summary and the test plan (the commands you ran and their result).

Keep a pull request to one concern. When it's merged, remove the worktree:
`git worktree remove .claude/worktrees/<short-description>`.

## Agent Setup

Claude Code reads `CLAUDE.md`, which imports this file. Other agents read this file directly.

| What | Lives In |
| --- | --- |
| Instructions | `AGENTS.md` |
| Rules, loaded by path | `.claude/rules/*.md` |
| Skills | `.claude/skills/*/SKILL.md` |
| Permissions, sandbox, hooks | `.claude/settings.json`; personal overrides in `.claude/settings.local.json` (not committed) |
| Hooks | `.claude/hooks/block-sensitive-files.sh` (before shell commands), `.claude/hooks/format.sh` (after edits) |

The settings deny the secrets above, allow `bin/lint` and `bin/test` without asking, ask before `cap` and pushes to
`main`, keep the sandbox's network to RubyGems, GitHub and the data sources, and run only `bin/test` outside the
sandbox. No test covers the agent setup: when you change it, try it in a session.
