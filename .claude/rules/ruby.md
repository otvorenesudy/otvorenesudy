---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "**/*.erb"
  - "Gemfile"
---

# Ruby 4.0 and Rails 8.1

The app runs **Ruby 4.0 and Rails 8.1** (`.ruby-version`, `Gemfile.lock`). Write current Ruby and Rails, and match the
surrounding code.

## Ruby and Rails

- Every Ruby file starts with `# frozen_string_literal: true`.
- Use what the versions give: `params.expect`, endless ranges (`where(date: ...Time.current)`), shorthand hash values
  (`{ court:, judge: }`), anonymous block forwarding (`&`), `filter_map`, `rfind`, `compact_blank`, `Data.define`.
- Strong parameters in the controller (`params.expect(subscription: [...])`); never mass-assign what a form doesn't
  offer.
- Background work: ActiveJob (`ApplicationJob`) on Sidekiq, queues `default`, `probe` and `utils`
  (`config/sidekiq.yml`). `UpdateRepositoryJob` stays a plain `Sidekiq::Job`: otvorenesudy-api pushes it as a raw
  payload, so its name, queue and arguments are a contract.
- Inside a model, `Query` resolves to Active Record's `AttributeMethods::Query`: refer to the model as `::Query`.
- Errors you rescue and report go through `Rails.error` (Sentry subscribes to it).

## Formatting and Lint

The PostToolUse hook runs `bin/lint --fix` on every Ruby file you write: RuboCop (`.rubocop.yml`: 120 columns, single
quotes, the Rails, RSpec, FactoryBot, Capybara and Performance cops) formats and checks it. Fix what it reports; a
`rubocop:disable` needs a reason after `--` on the same line.

## Style

- No comments that restate the code; guard clauses; a blank line between logical blocks; `unless` only without
  `else`; `present?`/`blank?`.
- Scopes are lambdas: `scope :by_type, ->(types) { where(court_type_id: Array.wrap(types).map(&:id)) }`.
- Models compose behavior from concerns: `Resource::*` (`app/models/resource/`) and per-model ones
  (`app/models/judge/`, `app/models/court/`).
- Business logic that isn't a model's goes to `app/services` as plain Ruby objects.
- Views build HTML with `tag`, `safe_join` and `to_sentence`; `html_safe` and `raw` only on markup we wrote, with a
  reason. Links to addresses from imported data go through `link_to_source`, which links only web addresses.
- Logging: `Rails.logger`, prefixed with the class, values in brackets: `"DecreeDocument # Fetched [#{url}]"`.
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## Where Code Goes

| Code | Place |
| --- | --- |
| Elasticsearch: mappings, facets, search, suggest, percolation, index lifecycle | `lib/probe/` and each model's `mapping`/`facets` |
| Faceted listings | controllers inherit `SearchController`; views in `app/views/<resource>/` and `app/views/facets/` |
| Front-end behavior | Stimulus controllers in `app/javascript/controllers/`, wired by `data-*` attributes |
| Loading the datasets in `data/` | `lib/tasks/process.rake` and `lib/tasks/dataset_loader.rb` |
| Jobs | `app/jobs/` |
| Mail | `app/mailers/`, views in `app/views/<mailer>/`; roadie inlines `mailer.scss` |
