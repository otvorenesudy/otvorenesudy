---
paths:
  - "spec/**/*"
---

# RSpec

The process is the `acceptance-first` skill: scenarios first, an end-to-end spec per scenario that fails on its
assertion, then the code. This is how to write those specs here, on **rspec-rails 8, FactoryBot, Capybara (rack_test
and headless Chrome through Selenium) and WebMock**, against the real PostgreSQL and Elasticsearch. Run them with
`bin/test <spec>`: it lints, prepares the test database and runs outside the Claude Code sandbox, which plain
`bundle exec rspec` can't (the app reads `.env` while it boots).

## Which Spec

| Behavior | Spec | Directory |
| --- | --- | --- |
| A page or user flow: listings, facets, details, accounts, subscriptions | System spec; rack_test by default, `:js` (headless Chrome) when it needs JavaScript | `spec/system/` |
| An endpoint: status, redirect, params, a document, an unsubscribe link | Request spec | `spec/requests/` |
| A rake task: subscription e-mails, sitemap, index maintenance | The task, with `perform_enqueued_jobs`; `type: :task` | `spec/tasks/` |
| A job, including the payload otvorenesudy-api pushes | The job, from the payload as the other app enqueues it | `spec/jobs/` |
| The search library | Its classes against the real index | `spec/lib/probe/` |
| Logic with many branches: normalizers, rankings, indicators, serialization | Model or service spec | `spec/models/`, `spec/services/` |

Don't add a model or service spec that repeats what an end-to-end spec already proves.

## Fakes

- Real models, the real database and search index, real jobs and mailers, FactoryBot factories.
- Fake only what we don't own, at the edge:
  - The court system's servers: `stub_request` (WebMock). Their names resolve to the addresses in
    `spec/support/court_system.rb`. No spec reaches the network, and Chrome resolves only localhost.
  - Mail: `ActionMailer::Base.deliveries`, cleared before every example.
  - The clock: `travel_to` / `freeze_time`.
  - Jobs: run them with `perform_enqueued_jobs` and assert the outcome; `have_enqueued_job` only when enqueueing is the
    behavior.
- Never `allow_any_instance_of`, and never doubles or stubs of this app's own classes. A double of something we don't
  own is verified (`instance_double`, `class_double`), and a message expectation is a spy: `allow(...)`, then
  `expect(...).to have_received(...)`. RuboCop enforces both.

## Writing Them

RuboCop runs the RSpec, FactoryBot and Capybara cops on every spec; these rules match them.

- `require 'rails_helper'`. `RSpec.describe ClassName` for a class, with `described_class` inside; a string for a page
  or flow (`RSpec.describe 'Courts'`). The directory sets the type.
- `describe` names a method (`'.search'`, `'#indicators'`) or a part of the page (`'the listing'`); `context` names a
  situation and starts with `when`, `with` or `without`. At most three levels of nesting.
- Example names state the outcome in the present tense, after the scenario:
  `it 'lists courts by name, 20 a page, with their count'`, never `it 'should ...'`.
- A subject the examples refer to is named: `subject(:court) { create(:court) }`. At most five `let`s in a group;
  `let!` only for a record that must exist before the example runs.
- Factories with parentheses: `create(:court)`, `create(:court, :regional)`, `build(:judge)`. They live in
  `spec/factories/`, minimal and realistic. Seeds (sources, court types, periods, decree forms) are loaded before the
  suite.
- A request or other spec checks a small cluster of outcomes of one behavior (at most 5 expectations, 15 lines). A
  system spec walks one scenario through the UI and has no such limit.
- Examples run in a transaction; `after_commit` callbacks still run, so records index themselves. Call
  `refresh_indices` before searching; the indices are emptied after every example.
- Judges the factories create get ids above those in the indicator datasets; give a judge an id from `data/*.csv` to
  test its indicators.
- No `sleep`, no dependence on order or on the time of day.

## System Specs

- rack_test by default; `:js` for headless Chrome when the flow needs JavaScript, `width: 390` for a phone.
  `bounds(element)` returns where the browser drew an element, for scenarios about the layout.
- Drive the page like a visitor: `visit`, `fill_in`, `click_on`, `select`, by the visible label or text. Assert what
  they see with Capybara's waiting matchers (`have_text`, `have_css`, `have_current_path`).
- Headings are uppercase on screen (CSS), so the browser reads them uppercase: match them case-insensitively, like the
  `heading` helper in `spec/system/courts_spec.rb`.
- A Stimulus controller connects after the page shows: hover with `hover_when_connected(element, 'tooltip')`.
- Sign in with `login_as user` (system) or `sign_in user` (request). `:error_pages` shows the error pages instead of
  raising.
- A `:js` example that fails prints the browser's console: read it before guessing.

## Never

- Skip, delete or loosen a failing spec to get green. If a spec is wrong, say which scenario it contradicts.
- Filter application code out of coverage. A full `bin/test` fails below 95% of lines or 90% of branches, and
  undercover reports every changed method no spec runs: cover them with specs.
