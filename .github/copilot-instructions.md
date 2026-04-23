# Open Courts (Otvorené Súdy) - Copilot Instructions

## Repository Overview

Civic-tech web application providing a user-friendly interface to Slovak judiciary public data from the [Department of Justice](http://www.justice.gov.sk) and [The Judicial Council](http://www.sudnarada.sk). Crawls, processes, indexes, and serves data about courts, judges, hearings, decrees, proceedings, and selection procedures with faceted search. **~356 Ruby files, ~12.5k lines, plus CoffeeScript/JS front-end.**

**Tech Stack**: Ruby 2.3.8, Rails 3.2.22.5, PostgreSQL 16 (pg_trgm, unaccent, pgvector), Elasticsearch 1.7 (via `tire` gem + custom `Probe` library), Redis/Sidekiq (< 4.0), Memcached (Dalli), CoffeeScript/jQuery/Bootstrap 4.1, SCSS, ERB views, Devise auth, Capistrano deployment, Unicorn (production)

**App module**: `OpenCourts` (version 5.0.1-alpha)

## Setup Instructions

```bash
git clone --recursive git://github.com/otvorenesudy/otvorenesudy.git
cd otvorenesudy
bundle install
cp config/configuration.{yml.example,yml}
cp config/database.{yml.example,yml}
# Edit config/configuration.yml and config/database.yml with your credentials
rake db:create
rake db:migrate  # or rake db:structure:load
rake db:seed
```

### Required Services

- **PostgreSQL 16** with extensions: `pg_trgm`, `unaccent`, `vector` (pgvector)
- **Elasticsearch 1.7** with Groovy dynamic scripting enabled
- **Redis** for Sidekiq background jobs
- **Memcached** for caching (Dalli)

### Environment Variables

From `config/database.yml`: `OPENCOURTS_DATABASE_USER`, `OPENCOURTS_DATABASE_PASSWORD`

From `config/configuration.yml`: `secret_token`, `rollbar.access_token`, `bing.key`, `devise.key`, `github.organization`, `github.repository`, `mailer.username`, `mailer.password`, `sidekiq.password`

## Development Guidelines

Always follow these instructions when making code changes.

**IMPORTANT**: Follow these rules strictly.

1. Do not put comments or documentation in code. Follow existing patterns. Only in case the logic is very complex or there is a non-obvious reason for something or TODO comments for edge cases.

2. This is a Rails 3.2 codebase — use Rails 3.2 conventions (`attr_accessible`, `before_filter`, old-style scope syntax). Do not introduce Rails 4+ patterns unless explicitly asked to upgrade.

3. Follow existing code style. Two-space indentation, no tabs, 120-character line width. Prefer single quotes for strings unless interpolation is needed.

4. Always write tests for new functionality and bug fixes. Follow existing RSpec patterns in `spec/` directory. Put tests in the same module structure as the code you're testing. Run tests via `bundle exec rspec` and make sure all tests pass before committing.

5. When writing specs, follow existing patterns. Use `FactoryGirl` (not `FactoryBot`) for factories — this codebase uses the older gem name. Use `let` for setup, `before` blocks for shared setup, and `describe`/`context` blocks for organization. Follow betterspecs.org guidelines.

6. When adding new dependencies:
   - Ruby gems: add to `Gemfile`, run `bundle install`, commit both `Gemfile` and `Gemfile.lock`.
   - Be careful with gem version compatibility — Rails 3.2 constrains many gem versions.

7. When committing code, commit messages should follow Conventional Commits format v1.0.0:
   - `feat: add new feature X`
   - `fix: resolve bug Y`
   - `docs: update documentation for Z`
   - `chore: update dependencies`

8. Use `Rails.logger` for logging. Avoid `puts` for debugging — use `pry` or `byebug`.

9. Construct file paths with `Rails.root.join(...)` instead of hardcoding.

10. Follow thin-controller pattern — move business logic into models, services, or lib modules.

11. For Sidekiq workers: pass IDs or serializable payloads, never ActiveRecord objects. Keep `perform` methods focused.

12. The `Probe` library (`lib/probe/`) is the custom Elasticsearch integration layer. Models include it via `include Probe` and define mappings/facets/search methods.

13. The `Core` library (`lib/core/`) provides the data ingestion pipeline framework: agent → crawler → parser → factory → persistor.

## Running Application

```bash
# Rails server
bundle exec rails server

# Sidekiq background worker
bundle exec sidekiq -C config/sidekiq.yml

# Both can also be started via Guard for development
bundle exec guard
```

## Running Tests

```bash
# All tests
bundle exec rspec

# Specific test file
bundle exec rspec spec/models/court_spec.rb

# Specific example
bundle exec rspec spec/models/court_spec.rb:42
```

Note: Transactional fixtures are disabled — tests use `DatabaseCleaner` (configured in `spec/support/database_cleaner.rb`).

## Project Structure

**Core Files**:

- `config/application.rb` — App bootstrap (`OpenCourts` module), timezone `Bratislava`, locale `:sk`
- `config/routes.rb` — RESTful routes for courts, judges, hearings, decrees, proceedings
- `config/database.yml` — PostgreSQL config (dev/test/prod databases)
- `config/sidekiq.yml` — 3 queues: `default`, `probe`, `utils`
- `config/probe.yml` — Elasticsearch index configuration (courts, judges, hearings, decrees, proceedings, selection procedures)
- `config/schedule.rb` — Cron jobs via `whenever` (daily/weekly/monthly subscriptions, sitemap, cache clearing)

**Key Directories**:

- `app/models/` — 71 ActiveRecord models (courts, judges, hearings, decrees, proceedings, property declarations, etc.)
- `app/models/court/` — Court-specific concerns (expenses, proceeding durations)
- `app/models/judge/` — 15 judge-specific concerns (indicators, incomes, activity, etc.)
- `app/models/resource/` — 11 shared model concerns (ContextSearch, Indicator, Ranking, Storage, Subscribable, URI, etc.)
- `app/controllers/` — 14 controllers (thin controllers delegating to models/services)
- `app/helpers/` — 20 view helpers
- `app/serializers/` — 11 ActiveModel serializers
- `app/services/` — `RepositoryManager` (Elasticsearch sync service)
- `app/jobs/` — 5 Sidekiq jobs (anonymize hearing, destroy model, sync/update repository, mark invalid PDFs)
- `app/views/` — ERB templates organized by resource (courts, judges, hearings, decrees, proceedings, etc.)
- `app/assets/javascripts/` — CoffeeScript + vanilla JS files
- `app/assets/stylesheets/` — SCSS with components/utilities organization
- `lib/probe/` — Custom Elasticsearch DSL (mapping, facets, search, suggest, percolation)
- `lib/core/` — Data ingestion framework (crawlers, parsers, factories, storage)
- `lib/justice_gov_sk/` — justice.gov.sk crawlers/parsers/processors
- `lib/nrsr_sk/` — Slovak parliament data integration
- `lib/sudnarada_gov_sk/` — Judicial council data integration
- `lib/bing/` — Bing search API integration
- `lib/tasks/` — 10 Rake task files (crawl, process, probe, backup, storage, subscriptions, etc.)
- `data/` — Static CSV/JSON datasets (court expenses, judge indicators, paragraphs, etc.)
- `spec/` — RSpec tests (models, lib, integration, serializers, factories)

**Database**: Schema managed via `db/structure.sql` (SQL format). Key tables: courts, judges, hearings, decrees, decree_pages, proceedings, employments, legislations, selection_procedures, subscriptions, users.

## Architecture Patterns

1. **Probe** — Custom Elasticsearch DSL in `lib/probe/` providing `mapping`, `facets`, `search`, `suggest`, `percolate` methods, mixed into models via `include Probe`
2. **Core** — Data ingestion framework in `lib/core/` with crawler → parser → factory → persistor pipeline
3. **Resource concerns** — Shared model behaviors via `Resource::URI`, `Resource::Storage`, `Resource::Subscribable`, `Resource::Indicator`, `Resource::Ranking`, etc.
4. **Rails 3.2 patterns** — Uses `attr_accessible` (mass assignment whitelist), `before_filter`, old-style scopes, `match` in routes
5. **Subscriptions** — Users subscribe to search queries and receive daily/weekly/monthly email notifications via cron (`whenever`)

## Common Issues & Solutions

**Ruby Version Mismatch** — "Your Ruby version is X, but Gemfile specified 2.3.8"
→ Install Ruby 2.3.8 via your version manager (rbenv/asdf)

**PostgreSQL Extensions** — Queries fail with missing function errors
→ Ensure `pg_trgm`, `unaccent`, and `vector` extensions are installed: `CREATE EXTENSION IF NOT EXISTS pg_trgm;` etc.

**Elasticsearch Connection** — Search features not working
→ Ensure Elasticsearch 1.7 is running. Check `config/probe.yml` for index configuration. Rebuild indices: `rake probe:reindex`

**Database Setup** — Schema load errors
→ Use `rake db:structure:load` (not `rake db:schema:load`) — this project uses SQL format schema

**Asset Pipeline** — CSS/JS not loading in development
→ `rake assets:precompile` or restart the Rails server

**Sidekiq Not Processing** — Background jobs stuck
→ Check Redis is running, Sidekiq started with correct config: `bundle exec sidekiq -C config/sidekiq.yml`

## Deployment

Deployment uses **Capistrano 3.4** with the following plugins:
- `capistrano-rbenv` — Ruby version management
- `capistrano-passenger` — App server restart
- `capistrano-sidekiq` — Background worker management
- `capistrano-git-submodule-strategy` — Git submodules
- `capistrano-sitemap_generator` — Sitemap generation
- `whenever/capistrano` — Cron schedule management

Deploy stages defined in `config/deploy/staging.rb` and `config/deploy/production.rb`.

## Quick Reference

```bash
# Essential commands
bundle install
rake db:migrate
bundle exec rspec
bundle exec rails server
bundle exec sidekiq -C config/sidekiq.yml

# Data pipeline
rake crawl:courts                           # Crawl court data
rake crawl:judges                           # Crawl judge data
rake crawl:selection_procedures             # Crawl selection procedures
rake crawl:judge_property_declarations      # Crawl property declarations
rake process:paragraphs                     # Process legislation paragraphs
rake process:court_expenses:2013            # Process court expenses
rake process:court_statistical_summaries:2012
rake process:judge_statistical_summaries:2012
rake probe:reindex                          # Rebuild Elasticsearch indices
rake subscriptions:run[daily]               # Run subscription emails

# File locations
app/models/           # ActiveRecord models
app/controllers/      # Controllers
app/views/            # ERB templates
app/helpers/          # View helpers
app/serializers/      # JSON serializers
app/jobs/             # Sidekiq jobs
app/services/         # Service objects
lib/probe/            # Elasticsearch DSL
lib/core/             # Data ingestion framework
lib/justice_gov_sk/   # Justice.gov.sk integration
lib/tasks/            # Rake tasks
spec/                 # RSpec tests
config/               # Configuration
data/                 # Static datasets (CSV/JSON)
db/structure.sql      # Database schema (SQL format)
```
