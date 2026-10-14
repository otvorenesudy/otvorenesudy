---
paths:
  - "**/*.rb"
  - "**/*.rake"
  - "Gemfile"
---

# Ruby 2.3 and Rails 3.2

The app runs **Ruby 2.3.8 and Rails 3.2.22** (`.ruby-version`, `Gemfile.lock`). Code that works on a current Ruby or
Rails often doesn't here. A move to Rails 8 is planned separately; until it lands, write for these versions and
match the surrounding code.

## Not Available

| Don't Use | Use |
| --- | --- |
| `filter_map`, `tally`, `then`/`yield_self`, `Hash#transform_values`/`transform_keys`, `String#delete_prefix`/`delete_suffix`, `Comparable#clamp`, `Array#filter` | `map { }.compact`, `each_with_object`/`group_by`, a local variable, `Hash[h.map { }]`, `sub(/\A.../, '')` |
| Numbered block parameters (`_1`, `it`), pattern matching, endless methods, `{ name: }` shorthand, `...` forwarding | Named block parameters and plain methods |
| `rescue` inside `do ... end` without `begin` | `begin ... rescue ... end` inside the block |
| `downcase`/`upcase` on Slovak text (ASCII only before Ruby 2.4) | The source's normalizers, `ActiveSupport::Multibyte` (`mb_chars.downcase`) |
| `find_by(name: x)`, `pluck(:a, :b)`, `update(attrs)`, `deliver_now`, `where.not`, `enum` | `where(name: x).first` or `find_by_name(x)`, `pluck(:a)` per column or `select`, `update_attributes`, `deliver`, `where('x <> ?', v)`, constants |
| Strong parameters (`params.require(...).permit`) | `attr_accessible` on the model lists what mass assignment may set |
| `before_action`, ActiveJob, `ApplicationRecord` | `before_filter`, Sidekiq workers (`include Sidekiq::Worker`, `perform_async`), `ActiveRecord::Base` |
| `Model.all` as a relation | `Model.scoped` (`all` returns an Array in Rails 3.2) |

Safe navigation (`&.`) and squiggly heredocs (`<<~`) do work: Ruby 2.3 added them.

## Formatting and Lint

The PostToolUse hook runs `bin/lint --fix` on every Ruby file you write: syntax_tree formats it (`.streerc`: 120
columns, single quotes, Ruby 2.3 syntax), then RuboCop's Lint and Security cops check it as Ruby 2.3
(`.rubocop.yml`). Both run from their own bundle in `tools/lint` on Ruby 3.3, because they no longer run on 2.3. Fix
what they report. Offenses in `.rubocop_todo.yml` predate the setup: leave them unless the change is about them.

## Style

- Files with Slovak text start with `# encoding: utf-8`, like their neighbors.
- No comments that restate the code; guard clauses; a blank line between logical blocks; `unless` only without
  `else`; `present?`/`blank?`.
- Scopes are lambdas: `scope :by_type, lambda { |types| where(court_type_id: Array.wrap(types).map(&:id)) }`.
- Models compose behavior from concerns: `Resource::*` (`app/models/resource/`) and per-model ones
  (`app/models/judge/`, `app/models/court/`).
- Configuration is `Configuration` (`app/models/configuration.rb`, from `config/configuration.yml`) and the per-source
  `*::Configuration` classes (Squire). You can't read `config/configuration.yml`; the `.example` shows its keys.
- Logging: `Rails.logger`, prefixed with the class, values in brackets.
- Names follow the `naming` skill: short in small scopes, descriptive for methods, parameters and anything public.

## Where Code Goes

| Code | Place |
| --- | --- |
| Elasticsearch: mappings, facets, search, suggest, percolation | `lib/probe/` and each model's `mapping`/`facets` |
| Crawling and processing sources | `lib/core/` plus a source module in `lib/justice_gov_sk/`, `lib/sudnarada_gov_sk/`, `lib/nrsr_sk/` |
| Sidekiq workers | `app/jobs/`, queues `default`, `probe`, `utils` (`config/sidekiq.yml`) |
| JSON | `app/serializers/` (ActiveModelSerializers) |
| Faceted listings | controllers inherit `SearchController`; views in `app/views/<resource>/` and `app/views/facets/` |
