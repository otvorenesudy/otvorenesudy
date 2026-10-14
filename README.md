# Open Courts (Otvorené súdy)

[![CI](https://github.com/otvorenesudy/otvorenesudy/actions/workflows/ci.yml/badge.svg)](https://github.com/otvorenesudy/otvorenesudy/actions/workflows/ci.yml)

A public data project that makes data about the Slovak judiciary usable: courts, judges, hearings, decrees and
proceedings from the [Ministry of Justice](https://www.justice.gov.sk), with faceted search, judges' indicators and
e-mail subscriptions to searches. It runs at [otvorenesudy.sk](https://otvorenesudy.sk).

[otvorenesudy-api](https://github.com/otvorenesudy/otvorenesudy-api) imports the court system's data into the shared
database; this app shows it and keeps the search indices up to date.

## Requirements

- Ruby 4.0 and Node 24 (`.tool-versions`; Node only runs Prettier, the app's JavaScript needs no build)
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

`bin/setup` installs the gems and Prettier, creates the database from `db/structure.sql` with its seeds, then starts
`bin/dev` (the app on port 3000 and the Dart Sass watcher). Build the search indices with `bin/rails probe:reindex`.

The database login comes from `OPENCOURTS_DATABASE_USER` and `OPENCOURTS_DATABASE_PASSWORD` (and
`OPENCOURTS_DATABASE_HOST`), in your environment or a `.env` file; without them PostgreSQL's defaults apply.

### A Copy of Production

With a dump of the production server (`db-backup-*.gz`), `bin/restore-production-copy <dump>` restores its
`opencourts_production` database as `opencourts_development`, 8 sessions at a time (`brew install gawk` makes its
first step, splitting the dump, eight times faster). It masks every user's e-mail address but yours
(`git config user.email`, or `--keep`), resets their passwords, takes away their admin rights and replaces the
subscriptions' unsubscribe tokens. Then reindex with `bin/rails probe:reindex`.

## Configuration

The environment, or a `.env` file (git ignores it), holds the database login, shared with otvorenesudy-api
(`OPENCOURTS_DATABASE_HOST`, `OPENCOURTS_DATABASE_USER`, `OPENCOURTS_DATABASE_PASSWORD`; on the server, the deploy
user's `~/.env`), and settings: optionally `REDIS_URL`, `ELASTICSEARCH_URL`, `RAILS_MAX_THREADS`, `SIDEKIQ_CONCURRENCY`
and `RAILS_LOG_LEVEL`.

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
