---
paths:
  - "spec/**/*"
---

# RSpec 8

The process is the `acceptance-first` skill: scenarios, an end-to-end spec per scenario that fails first, then code.
This is how to write those specs here, on **RSpec 8 (rspec-rails), FactoryBot, Capybara with Selenium and WebMock**.
Run them with `bin/test <spec>`; it prepares the test database and runs outside the Claude Code sandbox, which plain
`bundle exec rspec` can't (the app reads `.env` while it boots).

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| A page or user flow: listings, facets, details, accounts, subscriptions | System spec; rack_test by default, `:js` (headless Chrome) when it needs JavaScript | `spec/system/` |
| An endpoint: status, redirect, params, a document, an unsubscribe link | Request spec | `spec/requests/` |
| A rake task: subscription e-mails, sitemap, index maintenance | The task, with `perform_enqueued_jobs`; `type: :task` | `spec/tasks/` |
| A job, including the payload otvorenesudy-api pushes | The job | `spec/jobs/` |
| The search library | Its classes against the real index | `spec/lib/probe/` |
| Logic with many branches: normalizers, rankings, statistics, serialization | Model or service spec | `spec/models/`, `spec/services/` |

## Writing Them

- `require 'rails_helper'`, `RSpec.describe X do` with `described_class`; examples named after the scenario, in the
  present tense, stating the outcome: `it 'lists courts by name, 20 a page, with their count'`.
- FactoryBot (`create :court`, `create :employment, :inactive`); factories live in `spec/factories/`. Seeds (sources,
  court types, periods, decree forms) are loaded before the suite.
- Examples run in a transaction; `after_commit` callbacks still run, so records index themselves. Call
  `refresh_indices` before searching; the indices are emptied after every example.
- In the browser, headings are uppercase (CSS): match them case-insensitively (the `heading` helper in the system
  specs). Wait with Capybara's matchers; never `sleep`.
- Sign in with `login_as user` (system) or `sign_in user` (request). `:error_pages` shows the error pages instead of
  raising.
- Fake only what we don't own: the court system's documents with `stub_request`, mail through
  `ActionMailer::Base.deliveries`, the clock with `travel_to`. Never doubles of this app's classes.
- Never skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
