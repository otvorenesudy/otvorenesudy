---
paths:
  - "spec/**/*.rb"
---

# RSpec 2

The process is the `acceptance-first` skill: scenarios, an end-to-end spec per scenario that fails first, then code.
This is how to write those specs here, on **RSpec 2.14, FactoryGirl 4.4, Capybara 2.2 and DatabaseCleaner 0.9**.
Run them with `bin/test <spec>`; it prepares the test database and runs outside the Claude Code sandbox, which plain
`bundle exec rspec` can't (the app reads `.env` and `config/configuration.yml` while it boots).

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| A page or user flow: search, facets, detail pages, subscriptions, sign-up | Integration spec with Capybara (`visit`, `fill_in`, `click_button`, `expect(page).to have_content`) | `spec/integration/` |
| Search, facets, suggestions, percolation of a model | The shared examples in `spec/lib/probe/`, run from the model spec against a real index | `spec/models/` |
| Parsing a source page | Parser spec against a saved fixture (`load_fixture('justice_gov_sk/...')`) | `spec/lib/<source>/parser/` |
| Mail | Mailer spec, `ActionMailer::Base.deliveries` (`MailerHelper`) | `spec/mailers/` |
| Validations and model logic with branches | Model spec | `spec/models/` |
| JSON | Serializer spec | `spec/serializers/` |

## Writing Them

- `require 'spec_helper'` and a bare `describe Court do` (RSpec 2 style; no `RSpec.describe` prefix needed).
- `expect(...).to` for new code; the old `should` syntax still runs and appears in existing specs, but don't add it.
- FactoryGirl, not FactoryBot: `create :court`, `build :judge`, traits like `create :subscription, :weekly`.
  Factories live in `spec/factories/`.
- `db/seeds.rb` is loaded before every example (`spec/support/database_cleaner.rb`), so seeded lookups (court types,
  sources, forms) exist. Examples run in a transaction; pass `clean_with: :truncation` in the example's options when
  it needs committed data (search indexing, Capybara with a JavaScript driver).
- Search specs need Elasticsearch 1.7 on localhost:9200 and `reload_indices` after creating records.
- Fake only what we don't own: HTTP to the sources (saved fixtures), mail (test deliveries), time. Never
  `any_instance` stubs or doubles of this app's classes in integration specs.
- Example names state the outcome in the present tense, after the scenario: `it 'lists courts by name'`.
- Never skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
