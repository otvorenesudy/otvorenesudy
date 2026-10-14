# frozen_string_literal: true

require 'rails_helper'

# Enqueued by `bin/rails probe:import` (spec/tasks/probe_spec.rb), with the name of each model to reindex.
RSpec.describe Probe::ReindexJob do
  it 'refuses a model it does not index' do
    expect { described_class.perform_now('User') }.to raise_error(ArgumentError, "User isn't searchable")
  end
end
