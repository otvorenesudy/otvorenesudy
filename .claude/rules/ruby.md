---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "**/*.erb"
  - "Gemfile"
---

# Ruby 4.0 and Rails 8.1

The app runs **Ruby 4.0 and Rails 8.1** (`.ruby-version`, `Gemfile.lock`). Write current Ruby and Rails, and match the
surrounding code before anything here.

## Formatting and Lint

RuboCop formats and checks every Ruby file (`.rubocop.yml`): the community Ruby and Rails style guides, with the Rails,
RSpec, FactoryBot, Capybara and Performance cops on their defaults. The PostToolUse hook runs `bin/lint --fix` on each
file you write and sends back what it couldn't fix; fix that, don't hand-format. What the configuration settles:

- `# frozen_string_literal: true` opens every Ruby file (`bin/lint --fix` adds it).
- Single quotes, inside interpolation too; lines up to 120 columns.
- Methods up to 20 lines, classes and modules up to 200, ABC size 30, cyclomatic and perceived complexity 10. A method
  over them splits into private methods named after their steps; don't raise a limit or disable the cop.
- Numbers in names are separated by an underscore (`indicators_2013`): index fields, facet params and methods use it.
- No documentation comment is required above a class. A comment says what the code can't: a source's quirk, a
  constraint, an order that matters (`NameNormalizer::COURT_SPELLINGS`). Never one that restates the code.
- A `rubocop:disable` carries its reason after `--` on the same line.

## Ruby

- Use what the versions give: shorthand hash and keyword values (`{ court:, judge: }`, `reverse:`), endless ranges
  (`where(date: ...Time.current)`), anonymous block forwarding (`&`), `filter_map`, `sum`, `compact_blank`, and
  `Data.define` for small value objects (`JudgesController::Comparison`, `Probe::Mapping::Field`).
- Guard clauses and early returns over nested conditionals; a blank line between logical blocks; `unless` only without
  `else`.
- `present?`, `blank?`, `presence` and safe navigation (`&.`) over manual nil and empty checks.
- Enumerable over loops that fill an accumulator: `map`, `filter_map`, `each_with_object`, `reduce`, `group_by`,
  `uniq { }`.
- Stateless code is a module: `module_function` (`Court::Expenses`), or `extend self` when it has private helpers
  (`NameNormalizer`). A class with only class methods keeps its helpers private under `class << self`.
- Static mappings are frozen constants (`NameNormalizer::COURT_ABBREVIATIONS`).
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## Rails

- Controllers stay thin: find the records, call a model or service, render or redirect. Parameters come through
  `params.expect` (`params.expect(subscription: [{ query_attributes: %i[model value] }])`); never mass-assign what a
  form doesn't offer.
- Listing pages inherit `SearchController`, which runs the faceted search, suggestions and pagination; a resource's
  controller adds only `show` and its default sort (`CourtsController`).
- Models compose behavior from concerns: shared ones in `Resource::*` (`app/models/resource/`), a model's own in
  `app/models/<model>/` (`Judge::Indicators`, `Court::Expenses`).
- Scopes are lambdas: `scope :chair, -> { joins(:positions).merge(JudgePosition.chair) }`.
- Inside a model, `Query` resolves to Active Record's `AttributeMethods::Query`: refer to the model as `::Query`.
- Logic that isn't one model's goes to `app/services` as plain Ruby objects (`DecreeDocument`, `HearingAnonymizer`).
- Background work is ActiveJob (`ApplicationJob`) on Sidekiq, on the queues `default`, `probe` and `utils`
  (`config/sidekiq.yml`). Jobs take ids or serializable values, keep `perform` short and are safe to run twice.
  `UpdateRepositoryJob` stays a plain `Sidekiq::Job`: otvorenesudy-api pushes it as a raw payload, so its name, queue
  and arguments are a contract between the two apps.
- Iterate over large tables with `find_each` / `in_batches`, and `includes` what a page shows against N+1 queries:
  there are millions of decrees and hearings.
- The schema lives in `db/structure.sql`. otvorenesudy-api writes courts, judges, hearings and decrees into the same
  tables: a migration that touches them needs the matching change there, in its own pull request.
- Errors you rescue and still want to hear about go through `Rails.error` (`handle`, `report`); Sentry subscribes to it.
- User-facing text goes through `t(...)`, with every key in both `config/locales/sk.yml` and `en.yml`; missing
  translations raise in development and tests.
- Secrets come from Rails credentials or ENV, never from code. You can't read them; ask the user when a change needs a
  new one.
- Log through `Rails.logger`, prefixed with the class, values in brackets:
  `"DecreesController # Document of decree [#{@decree.id}] unavailable: #{e.message}"`. Rake tasks may `puts` their
  progress; nothing else does.

## Views

- ERB, which no formatter checks: keep the indentation of the surrounding markup.
- Build HTML with helpers: `tag`, `link_to`, `safe_join`, `to_sentence`. `html_safe` and `raw` only on markup we wrote,
  with a reason.
- Links to addresses from imported data go through `link_to_source`, which links only web addresses.
- Behavior is a Stimulus controller wired with `data-*` attributes (the `javascript` rule); no inline scripts or styles.

## Where Code Goes

| Code | Place |
| --- | --- |
| Elasticsearch: mappings, facets, search, suggest, percolation, index lifecycle | `lib/probe/` and each model's `mapping`/`facets` |
| Faceted listings | Controllers inheriting `SearchController`; views in `app/views/<resource>/` and `app/views/facets/` |
| Front-end behavior | Stimulus controllers in `app/javascript/controllers/` |
| Loading the datasets in `data/` | `lib/tasks/process.rake` and `lib/tasks/dataset_loader.rb` |
| Jobs | `app/jobs/` |
| Mail | `app/mailers/`, views in `app/views/<mailer>/`; roadie inlines `mailer.scss` |
