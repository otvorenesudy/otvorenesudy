# frozen_string_literal: true

# The judge indicator datasets are read once per process and keyed by the judges that exist then; each example starts
# without them, so they're read against its own judges.
RSpec.configure do |config|
  # Judges the factories create get ids above those in the datasets, so they have no indicators unless given an id.
  config.before(:suite) do
    ActiveRecord::Base.connection.execute('ALTER SEQUENCE judges_id_seq RESTART WITH 1000000')
  end

  config.before do
    [Judge::Indicators2013, Judge::Indicators2015, Judge::Indicators2017].each { |year| year::DATASET.reset! }
    Judge::Indicators2021.reset!
  end
end
