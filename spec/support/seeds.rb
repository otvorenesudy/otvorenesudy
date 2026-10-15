# frozen_string_literal: true

# Every example runs in a transaction on a database holding just the seeds (sources, court types, decree forms...),
# committed once before the suite.
RSpec.configure do |config|
  config.before(:suite) do
    connection = ActiveRecord::Base.connection
    tables = connection.tables - %w[schema_migrations ar_internal_metadata]

    connection.truncate_tables(*tables)

    Rails.application.load_seed
  end
end
