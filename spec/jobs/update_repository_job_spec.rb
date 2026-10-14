# frozen_string_literal: true

require 'rails_helper'

# otvorenesudy-api writes courts, judges, hearings and decrees to the shared database, then pushes this job to Redis as
# a raw payload (UpdateNotifier): class, queue and arguments must stay as they are.
RSpec.describe UpdateRepositoryJob do
  def push(model_name, id)
    Sidekiq::Client.push('class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => [model_name, id])
  end

  def names
    Court.client.indices.refresh(index: Court.index_name)

    Court.search({}).records.map(&:name)
  end

  it 'reindexes a record the API changed' do
    court = create(:court, name: 'Okresný súd Starý')
    court.update_column(:name, 'Okresný súd Nový') # rubocop:disable Rails/SkipsModelValidations -- as the API writes

    push('Court', court.id)

    expect(described_class.jobs.sole).to include('queue' => 'probe', 'args' => ['Court', court.id])

    described_class.drain

    expect(names).to eq(['Okresný súd Nový'])
  end

  it 'skips a record deleted meanwhile' do
    push('Decree', 0)

    expect { described_class.drain }.not_to raise_error
  end

  it 'ignores a model it does not index' do
    user = create(:user)

    push('User', user.id)

    expect { described_class.drain }.not_to raise_error
  end
end
