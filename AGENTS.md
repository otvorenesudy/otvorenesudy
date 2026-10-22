# otvorenesudy: Agent Instructions

[Open Courts](https://otvorenesudy.sk) (Otvorené súdy), the public website of a project that makes data about the
Slovak judiciary usable: courts, judges, hearings, decrees, proceedings, judge selection procedures (hidden since
October 2025), statistics and property declarations, with faceted search and e-mail subscriptions to searches.
**Rails 8.1 on Ruby 4.0**, PostgreSQL (pg_trgm, unaccent, pgvector), Elasticsearch 9 through the in-house `Probe`
library (`lib/probe`), Sidekiq 8, Memcached, Importmap with Stimulus and Turbo, Bootstrap 5.3 through Dart Sass, and
Sentry for errors.

| Repository | What It Is | How It Relates |
| --- | --- | --- |
| otvorenesudy-api | Importers and the JSON API | Writes courts, judges, hearings and decrees into this app's database, then pushes `UpdateRepositoryJob` here to reindex them |
| otvorenesudy-data | Static datasets (CSV, JSON, judges' CVs) | Checked out here as the `data` submodule; `rake process:*` and the judge indicators read it |
| otvorenesudy-prokuratura | The prosecutors' website | Sibling app on the same server |
| otvorenesudy-server | Ansible provisioning of the production server | Runs this app: nginx, Passenger, PostgreSQL, Elasticsearch 9, Redis, Memcached |

## How We Work: Acceptance First

Every feature, behavior change and bug fix starts as an acceptance test. Use the `acceptance-first` skill before
writing code; this is the summary. Tooling, deployment, configuration and refactors that keep behavior get no new
tests: check them by running them and the suite.

1. **Scenarios first**: each scenario the user gave, verbatim, plus edge cases (no results; Slovak diacritics in a
   query; a facet with nothing selected; a judge at several courts; a record updated after it was indexed). A bug fix
   starts with the bug as scenario 1.
2. **An end-to-end spec per scenario, red first.** Run it and watch it fail on its assertion.
3. **Implement outside-in** until it passes. Unit specs only for logic with many branches (normalizers, indicators,
   rankings, the search library).
4. **Done** means every scenario's spec passes and `bin/test` is green, with its output shown.

| Behavior | Tested Through | Where |
| --- | --- | --- |
| Pages and user flows: listings, facets, details, accounts, subscriptions | System specs with Capybara: rack_test, or headless Chrome (`:js`) when the flow needs JavaScript | `spec/system/` |
| Endpoints: statuses, redirects, params, documents, unsubscribe links | Request specs | `spec/requests/` |
| Scheduled and maintenance tasks: subscription e-mails, sitemap, index maintenance | The rake task, with `perform_enqueued_jobs` | `spec/tasks/` |
| Jobs, including the contract with otvorenesudy-api | The job, from its raw payload where another app enqueues it | `spec/jobs/` |
| The search library, models and services with many branches | Specs against the real index and database | `spec/lib/`, `spec/models/`, `spec/services/` |

Use real collaborators: our code, Rails, PostgreSQL and Elasticsearch. Fake only what we don't own, at the edge: the
court system's documents (WebMock), mail delivery and the clock. Never skip, delete or loosen a failing spec to get
green; if a spec is wrong, say which scenario it contradicts.

Specs that search call `refresh_indices` after creating records: records index themselves on commit, and the indices
are emptied after every example. Judges the factories create get ids above those in the indicator datasets; give a
judge an id from `data/*.csv` to test its indicators.

## Commands

```bash
bin/setup                    # gems, Node packages, the database; then bin/elasticsearch --daemon
bin/dev                      # the app and Dart Sass in watch mode
bin/test                     # lint, then every spec with coverage, then undercover; must be green before you are done
bin/test spec/system/courts_spec.rb:12   # lint, then those specs
bin/lint                     # RuboCop and Prettier on the files this branch changed
bin/lint --fix <file>        # format and autocorrect a file (the edit hook does this for you)
bin/vendor                   # copy the browser libraries package.json lists into vendor/ (npm install first)
bin/elasticsearch --daemon   # Elasticsearch 9 on localhost:9200, downloaded on first use
bin/rails probe:reindex      # rebuild the search indices from the database
bundle exec sidekiq -C config/sidekiq.yml
```

`bin/test` needs, on localhost:

- **PostgreSQL** with pg_trgm, unaccent and pgvector. It rebuilds `opencourts_test` from `db/structure.sql`.
- **Elasticsearch 9** (`bin/elasticsearch --daemon`). Without it, `bin/test` stops and says so.
- **Chrome** for the `:js` specs; Selenium Manager fetches the matching chromedriver.

It holds a machine-wide lock, because otvorenesudy-api uses the same test database, and runs outside the Claude Code
sandbox, because the app reads `.env` while it boots. Run specs through it rather than `bundle exec rspec`, which the
sandbox can't boot.

A full run measures coverage: SimpleCov fails below 95% of lines or 90% of branches, and undercover reports every
method this branch changed that no spec runs. Rake tasks, configuration and the hidden selection procedures aren't
measured. Cover what undercover reports with specs; never filter application code out of coverage.

## Code Conventions

- **Engineering**: the `engineering` skill. Small reviewable changes, the simplest thing that works, match the
  surrounding code, production-ready only.
- **Naming**: the `naming` skill. Short names in small scopes; descriptive names for methods, parameters, fields
  and anything public; precise nouns and verbs, no filler words.
- **Names people read** (CI workflows, jobs and steps, headings, table columns, English UI labels): title case, the
  `title-case` skill. "Check Out Repository", not "Checkout repository".
- **Rules** in `.claude/rules/` load when you touch the files they cover: `ruby`, `rspec`. Follow them.
- **Formatting is automatic.** After every edit a hook runs `bin/lint --fix` on the file and sends back what it
  couldn't fix. Fix those; don't hand-format.

  | Files | Tools | Settings |
  | --- | --- | --- |
  | `*.rb`, `*.rake`, `Gemfile`, `Capfile` | RuboCop with the Rails, RSpec, FactoryBot, Capybara and Performance cops | `.rubocop.yml` (120 columns, single quotes) |
  | `app/javascript/**/*.js`, `app/assets/stylesheets/**/*.scss` | Prettier | `.prettierrc.json` |

  ERB has no formatter here.
- **Front end**: behavior lives in Stimulus controllers (`app/javascript/controllers`), wired by `data-*` attributes;
  no inline scripts. Third-party libraries are listed in `package.json` at exact versions and copied into `vendor/`
  by `bin/vendor`, never edited by hand; `config/importmap.rb` pins them. To add or update one, change
  `package.json`, run `npm install` and `bin/vendor`; `bin/test` fails while the files don't match.
- **Translations**: Slovak is the default locale, English the other; user-facing strings go through `t(...)` with
  keys in both. Missing translations raise in development and tests.
- **Dependencies**: add with `bundle add` and commit `Gemfile.lock`.

## Secrets

These files hold credentials. Never read, print, copy or decrypt them, and don't ask to; when a change needs a
secret, ask the user to add it.

| File | What |
| --- | --- |
| `.env`, `.env.local` | The database login (host, user, password), shared with otvorenesudy-api, and settings |
| `config/master.key`, `config/credentials/*.key` | Keys of the encrypted credentials; `config/credentials/*.yml.enc` are the encrypted files. Production's hold the other secrets: `secret_key_base`, `devise.key`, `smtp.*`, `sentry.dsn`, `skylight.token` (`config/initializers/production_boot_check.rb` lists them) |
| `config/configuration.yml` | The Rails 3.2 app's secrets, no longer read; delete it once they are in the credentials |

Claude Code denies them to its file tools (`permissions.deny`) and to sandboxed commands
(`sandbox.filesystem.denyRead`), and a hook blocks shell commands that name them. `config/database.yml` only refers
to ENV and is fine to read. `db-backup-*.gz` in the workspace is a production dump: only the user restores it, with
`bin/restore-production-copy`, which masks users' e-mail addresses on the way in.

## Commits, Branches and Pull Requests

Nothing deploys automatically: a maintainer deploys with Capistrano (`bundle exec cap production deploy`). Changes
reach `main` through reviewed pull requests; CI (`.github/workflows/ci.yml`) runs `bin/test`.

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
