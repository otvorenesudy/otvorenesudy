# Open Courts (Otvorené súdy)

[![CI](https://github.com/otvorenesudy/otvorenesudy/actions/workflows/ci.yml/badge.svg)](https://github.com/otvorenesudy/otvorenesudy/actions/workflows/ci.yml)

A public data project that makes data about the Slovak judiciary usable: courts, judges, hearings, decrees and
proceedings from the [Ministry of Justice](https://www.justice.gov.sk), with faceted search, judges' indicators and
e-mail subscriptions to searches. It runs at [otvorenesudy.sk](https://otvorenesudy.sk).

[otvorenesudy-api](https://github.com/otvorenesudy/otvorenesudy-api) imports the court system's data into the shared
database; this app shows it and keeps the search indices up to date.

## Requirements

- Ruby 4.0 and Node 24 (`.tool-versions`; Node runs Prettier and `bin/vendor`, the app's JavaScript needs no build)
- PostgreSQL 17 with the pg_trgm, unaccent and pgvector extensions
- Elasticsearch 9 (`bin/elasticsearch` downloads and runs it locally)
- Redis (Sidekiq) and Memcached (cache, in production)
- Chrome, for the specs that need JavaScript

## Setup

```sh
git clone --recursive git@github.com:otvorenesudy/otvorenesudy.git
cd otvorenesudy
bin/elasticsearch --daemon
bin/setup
```

`bin/setup` installs the gems and the Node packages, makes `.env` and `.env.test` from their templates (see
[Configuration](#configuration)), creates the database from `db/structure.sql` with its seeds, then starts `bin/dev`
(the app on port 3000 and the Dart Sass watcher). Build the search indices with `bin/rails probe:reindex`.

### A Copy of Production

With a dump of the production server (`db-backup-*.gz`), `bin/restore-production-copy <dump>` restores its
`opencourts_production` database as `opencourts_development`, 8 sessions at a time (`brew install gawk` makes its
first step, splitting the dump, eight times faster). It masks every user's e-mail address but yours
(`git config user.email`, or `--keep`), resets their passwords, takes away their admin rights and replaces the
subscriptions' unsubscribe tokens. Then reindex with `bin/rails probe:reindex`.

## Configuration

The environment holds the settings: the database login, shared with otvorenesudy-api (`OPENCOURTS_DATABASE_HOST`,
`OPENCOURTS_DATABASE_USER`, `OPENCOURTS_DATABASE_PASSWORD`; without them PostgreSQL's defaults apply, your own user on
localhost), and optionally `REDIS_URL`, `ELASTICSEARCH_URL`, `RAILS_MAX_THREADS`, `SIDEKIQ_CONCURRENCY` and, in
production, `RAILS_LOG_LEVEL`. On the server they come from the deploy user's `~/.env`; production reads no dotenv
file.

In development and the tests, dotenv-rails also reads them from dotenv files, never overriding a variable the
environment already has, the first file that sets a variable winning: `.env.development.local`, `.env.local`,
`.env.development` and `.env` in development; `.env.test.local`, `.env.test` and `.env` in the tests.

| File | In Git | What It Holds |
| --- | --- | --- |
| `.env.example` | Committed | The template of `.env`: every setting, with its default |
| `.env` | Ignored | Your settings, in development and, as defaults, in the tests; `bin/setup` makes it from `.env.example` |
| `.env.test.example` | Committed | The template of `.env.test` |
| `.env.test` | Ignored | The tests' settings, over `.env`'s; `bin/setup` makes it from `.env.test.example` |
| `.env.ci` | Committed | CI's settings: the workflow copies it to `.env.test` |
| `.env.local`, `.env.*.local` | Ignored | Optional overrides of your own; the tests don't read `.env.local` |

Change your copies, not the templates, which are committed and hold no secrets; when a template gains a setting, add it
to your copy. The tests' database login needs to create databases and roles, so it is a superuser: `bin/test`
recreates `opencourts_test`, which otvorenesudy-api's tests share, and a spec restores a dump with its roles.
`.env.test.example` leaves it to your own user, a superuser on Homebrew's PostgreSQL.

The other secrets live only in Rails' encrypted credentials: `config/credentials/production.yml.enc`, with its key in
`config/credentials/production.key` (on the server, linked by Capistrano; never committed). Production doesn't boot
without them and names the ones missing (`config/initializers/production_boot_check.rb`):

```yaml
secret_key_base: ...       # signs sessions and cookies
devise:
  key: ...                 # keep the old one, so sent confirmation and password links keep working
smtp:
  username: ...
  password: ...
sentry:
  dsn: ...
  traces_sample_rate: 0.1  # optional
skylight:
  token: ...
elasticsearch:             # optional, for an Elasticsearch with security on
  url: ...
  api_key: ...
  ca_fingerprint: ...
```

Edit them with `bin/rails credentials:edit --environment production`. Development needs none of them; to try
e-mail, Sentry or Skylight locally, make your own from `config/credentials/development.example` with
`bin/rails credentials:edit --environment development` (git ignores them).

## Data

The seeds (`db/seeds.rb`) hold the code lists the app needs: sources, court types, hearing types, decree forms,
periods. Courts, judges, hearings and decrees come from otvorenesudy-api. The datasets in `data/` (the
[otvorenesudy-data](https://github.com/otvorenesudy/otvorenesudy-data) submodule) load with `rake process:*`:

```sh
bin/rails process:paragraphs
bin/rails process:court_acronyms
bin/rails process:court_expenses:2013            # also 2010, 2011, 2012
bin/rails process:court_statistical_summaries:2012
bin/rails process:judge_statistical_summaries:2012
bin/rails process:judge_designations:nrsr_sk     # and prezident_sk
```

The judges' indicators (2013, 2015, 2017 and 2021) are read from `data/` as the pages need them.

## Search

Each searchable model (courts, judges, hearings, decrees, proceedings) has an index behind an alias, built by
`lib/probe`. otvorenesudy-api reindexes what it imports through `UpdateRepositoryJob`; the indices can also be
maintained by hand (`INDICES=courts,judges` limits a task to those):

```sh
bin/rails probe:reindex        # rebuild in a new index, then switch the alias to it
bin/rails probe:import         # the same, in the background (Sidekiq)
bin/rails probe:synchronize    # reindex what is missing or older than the database (Sidekiq)
```

## Browser Libraries

pdf.js, Bootstrap, Popper, Chart.js and the cookie consent banner are listed in `package.json` at exact versions, and
`bin/vendor` copies them from `node_modules` into `vendor/` and `app/assets/stylesheets/vendor/`, bundling Popper and
Chart.js into one module each with esbuild. importmap serves them without a build step. Don't edit those files: to
update a library, change its version in `package.json` (Dependabot proposes updates weekly), then run `npm install`
and `bin/vendor` and commit what changed. Bootstrap's SCSS comes from the bootstrap gem, which must be the same
version. `bin/test` runs `bin/vendor --check`, which fails when the files aren't what `package.json`'s versions make.

## Testing

```sh
bin/test                                # lint, every spec with coverage, undercover
bin/test spec/system/courts_spec.rb     # lint, then those specs
bin/lint --fix                          # RuboCop and Prettier on what the branch changed
```

`bin/test` needs PostgreSQL and Elasticsearch running locally; CI runs it on every pull request.

## Deployment

A maintainer deploys `main` with Capistrano: `bundle exec cap production deploy`. The server is provisioned by
[otvorenesudy-server](https://github.com/otvorenesudy/otvorenesudy-server). Cron jobs (`config/schedule.rb`) send the
subscription e-mails, refresh the sitemap and check the indices.

## License

[Educational Community License 1.0](http://opensource.org/licenses/ecl1.php)
