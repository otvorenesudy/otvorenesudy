# frozen_string_literal: true

require 'rails_helper'
require 'rake'

# Index maintenance, run by the maintainers on the courts index here (INDICES=courts).
RSpec.describe 'probe tasks', type: :task do
  around do |example|
    indices = ENV.fetch('INDICES', nil)
    ENV['INDICES'] = 'courts'
    example.run
  ensure
    ENV['INDICES'] = indices
  end

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('probe:synchronize')
  end

  def run(task)
    perform_enqueued_jobs { Rake::Task["probe:#{task}"].tap(&:reenable).invoke }
  end

  def names
    refresh_indices

    Court.search({}).records.map(&:name).sort
  end

  it 'synchronize reindexes the records whose document is missing or older' do
    missing = create(:court, name: 'Okresný súd Chýbajúci')
    stale = create(:court, name: 'Okresný súd Starý')
    Court.client.delete(index: Court.index_name, id: missing.id, refresh: true)
    stale.update_columns(name: 'Okresný súd Nový', updated_at: 1.minute.from_now) # rubocop:disable Rails/SkipsModelValidations

    expect { run('synchronize') }.to output(/Synchronizing/).to_stdout

    expect(names).to eq(['Okresný súd Chýbajúci', 'Okresný súd Nový'])
  end

  it 'import rebuilds an index in the background, in a new index' do
    create(:court, name: 'Okresný súd Košice I')
    before = Court.client.indices.get_alias(name: Court.index_name).keys

    expect { run('import') }.to output(/Enqueuing reindex/).to_stdout

    expect(Court.client.indices.get_alias(name: Court.index_name).keys).not_to eq(before)
    expect(names).to eq(['Okresný súd Košice I'])
  end

  it 'reindex rebuilds an index at once' do
    create(:court, name: 'Okresný súd Košice I')

    expect { run('reindex') }.to output(/Reindexing/).to_stdout

    expect(names).to eq(['Okresný súd Košice I'])
  end

  it 'drop empties an index' do
    create(:court)

    expect { run('drop') }.to output(/Dropping/).to_stdout

    expect(names).to be_empty
  end
end
