# frozen_string_literal: true

# Coverage on full runs (bin/test sets COVERAGE): SimpleCov with branches, and the report undercover reads to check
# that every changed method is covered. Rake tasks, configuration and the hidden selection procedures aren't measured.
if ENV['COVERAGE']
  require 'simplecov'
  require 'undercover/simplecov_formatter'

  SimpleCov.start 'rails' do
    enable_coverage :branch

    add_filter %r{^/(bin|config|data|db|lib/tasks|script|spec|tmp|vendor)/}
    add_filter(/selection_procedure/)

    minimum_coverage line: 95, branch: 90

    formatter SimpleCov::Formatter::MultiFormatter.new(
      [SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::Undercover]
    )
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end
