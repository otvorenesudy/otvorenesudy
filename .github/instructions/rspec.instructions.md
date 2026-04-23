---
name: RSpec Testing
description: Instructions for writing tests in RSpec. Use these instructions when asked to write tests or review written tests for Ruby or Ruby on Rails code with RSpec library.
applyTo: "spec/**/*_spec.rb"
---

# RSpec Testing Style

Use this skill whenever generating tests. Follow existing patterns in this repo and principles from betterspecs.org.

## General RSpec Conventions

- Use `require 'rails_helper'` for model, lib, and integration specs.
- Use `require 'spec_helper'` for any simple objects or library code.
- Use `RSpec.describe ClassName, type: :model do` (or other appropriate type).
- Prefer `subject { build(:model) }` or `subject(:name) { ... }` when it makes expectations concise.
- Use `let` for lazily evaluated setup data; use descriptive names.
- Organize specs with `describe` for methods or features, and `context` for conditions.
- Use one assertion per example where practical, but allow a small cluster where it clearly checks a single behavior.
- Use `FactoryBot` factories instead of manual model construction.
- Use `expect(...).to` and `expect { ... }.to` (for side effects and errors).
- Always use present simple verbs in third person, e.g. `it 'fails'`, never `it 'should return ...'`. 
- Define the messages with clear descriptions, use `context` for different scenarios, e.g. 

```
RSpec.describe "Downloader" do
  context "when website is unavailable" do
    it "fails" do
    end
  end
end
```

- Use `context` for describing situation and `describe` to separate logical parts, e.g. see `Validations`.

## Model Specs

Example: Office model validations

```ruby
require 'rails_helper'

RSpec.describe Office, type: :model do
  subject { build(:office) }

  describe 'Validations' do
    it { is_expected.to belong_to(:genpro_gov_sk_office).optional(true) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_presence_of(:registry) }

    it 'validates correct schema of registry' do
      subject.registry = {
        phone: '123',
        hours: {
          monday: '8:00 - 15:00',
          tuesday: '8:00 - 15:00',
          wednesday: '8:00 - 15:00',
          thursday: '8:00 - 15:00',
          friday: '8:00 - 15:00'
        }
      }

      expect(subject).to be_valid

      subject.registry = {
        phone: '123',
        hours: {
          monday: '8:00 - 15:00',
          tuesday: '8:00 - 15:00',
          wednesday: '',
          thursday: '8:00 - 15:00',
          friday: '8:00 - 15:00'
        }
      }

      expect(subject).not_to be_valid
      expect(subject.errors.full_messages).to eql(['Registry is invalid'])
    end
  end
end
```

When generating model specs:

- Group validation and association matchers inside a `describe 'Validations'` or `describe 'Associations'` block.
- Test custom validation logic with concrete example hashes and explicit error messages.
- Use `is_expected.to` form with shoulda-matchers for conciseness.

## Simple Model Example

```ruby
require 'rails_helper'

RSpec.describe Prosecutor, type: :model do
  subject { build(:prosecutor) }

  it { is_expected.to belong_to(:genpro_gov_sk_prosecutors_list).optional(true) }
  it { is_expected.to validate_presence_of(:name) }
end
```

## Lib Specs

Example: Downloader behavior with doubles and logging

```ruby
require 'rails_helper'

RSpec.describe Downloader do
  describe '.download' do
    let(:url) { 'https://example.com/test.csv' }
    let(:body) { 'test content' }

    context 'with successful download' do
      it 'returns body when no block given' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform)
        allow(curl).to receive(:response_code).and_return(200)
        allow(curl).to receive(:body_str).and_return(body)

        result = described_class.download(url)

        expect(result).to eq(body)
      end

      it 'yields body to block when block given' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform)
        allow(curl).to receive(:response_code).and_return(200)
        allow(curl).to receive(:body_str).and_return(body)

        result = described_class.download(url) { |b| b.upcase }

        expect(result).to eq('TEST CONTENT')
      end
    end

    context 'with HTTP error' do
      it 'does not raise on 3xx redirect codes' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform)
        allow(curl).to receive(:response_code).and_return(301)
        allow(curl).to receive(:body_str).and_return(body)

        result = described_class.download(url)

        expect(result).to eq(body)
      end

      it 'retries on 4xx and 5xx response codes' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform)
        allow(curl).to receive(:response_code).and_return(500, 200)
        allow(curl).to receive(:body_str).and_return(body)
        allow(Rails.logger).to receive(:info)

        result = described_class.download(url, retries: 3)

        expect(result).to eq(body)
      end

      it 'raises after max retries' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform)
        allow(curl).to receive(:response_code).and_return(500)
        allow(Rails.logger).to receive(:info)
        allow(Rails.logger).to receive(:error)

        expect { described_class.download(url, retries: 3) }.to raise_error(Downloader::DownloadError)
      end
    end

    context 'with network error' do
      it 'retries on Curl errors' do
        curl = instance_double(Curl::Easy)

        allow(Curl::Easy).to receive(:new).with(url).and_return(curl)
        allow(curl).to receive(:timeout=)
        allow(curl).to receive(:connect_timeout=)
        allow(curl).to receive(:perform).and_raise(Curl::Err::GotNothingError).once.and_return(nil)
        allow(curl).to receive(:response_code).and_return(200)
        allow(curl).to receive(:body_str).and_return(body)
        allow(Rails.logger).to receive(:info)

        result = described_class.download(url, retries: 3)

        expect(result).to eq(body)
      end
    end
  end
end
```

When generating lib specs:

- Use `instance_double` for external dependencies (e.g., `Curl::Easy`).
- Stub only the methods used in the implementation (`timeout=`, `perform`, etc.).
- Use separate examples for success, retry, and error behaviors.
- Stub logging with `allow(Rails.logger).to receive(:info)` / `.error` where needed.

## Database & Test Environment

Patterns from `rails_helper.rb`:

- DatabaseCleaner is configured globally.
- `config.use_transactional_fixtures = false` and `DatabaseCleaner` wraps each example.
- Seeds can be loaded via metadata (e.g., `:seeds` flag).

When writing tests that depend on seeds:

```ruby
RSpec.describe 'Something', :seeds do
  # examples that assume Rails.application.load_seed has been called
end
```

## Betterspecs-aligned Guidelines

- **Describe the behavior, not the implementation**: Example descriptions should state what the code does (e.g., `'returns body when no block given'`).
- **Use contexts for branches**: Wrap conditionals (`with successful download`, `with HTTP error`) in `context` blocks.
- **Avoid unnecessary `before` blocks**: Prefer `let` and explicit setup inside `it` blocks unless shared across many examples.
- **One expectation per behavior**: Keep examples small and focused; multiple expectations are acceptable when they verify one coherent behavior.
- **Use `described_class`**: Refer to the subject under test via `described_class` instead of hardcoding the class name inside the block.
- **Isolate external services**: Stub network calls, file system, and external APIs; never hit real services.

## Writing New Specs

When Copilot generates new specs:

- Choose the correct spec type via directory and `type:` metadata (`models`, `lib`, `features`, etc.).
- Follow the nesting: `describe '#instance_method'` or `describe '.class_method'` inside the main `RSpec.describe`.
- Use factories from `spec/factories` (create new ones if needed, keeping them minimal and realistic).
- Prefer clear example names, e.g.:
  - `it 'returns matching offices ordered by name'`.
  - `it 'enqueues job with correct arguments'`.
- For background jobs, test both enqueueing and the `perform` behavior in isolation, using `perform_now`/`perform_later` or the configured job testing helpers.
