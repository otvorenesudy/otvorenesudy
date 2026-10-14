# frozen_string_literal: true

# The judge indicator datasets are read once per process and keyed by the judges that exist then; each example starts
# without them, so they're read against its own judges.
RSpec.configure do |config|
  config.before do
    [Judge::Indicators2013, Judge::Indicators2015, Judge::Indicators2017].each { |year| year::DATASET.reset! }
    Judge::Indicators2021.reset!
  end
end
