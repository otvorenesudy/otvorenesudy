# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Probe::Index do
  def case_numbers
    Hearing.search({}).records.map(&:case_number).sort
  end

  def version(model, record)
    model.client.get(index: model.index_name, id: record.id)['_version']
  end

  # The errors handed to Rails.error (and so to Sentry) while the block runs.
  def reported_errors
    errors = []
    subscriber = Class.new { define_method(:report) { |error, **| errors << error } }.new
    Rails.error.subscribe(subscriber)

    yield

    errors
  ensure
    Rails.error.unsubscribe(subscriber)
  end

  # The nightly check of the hearings and decrees indices (config/schedule.rb).
  describe '.recheck_index' do
    it 'indexes the records missing from the index' do
      hearing = create(:hearing, case_number: '1C/1/2026')
      Hearing.client.delete(index: Hearing.index_name, id: hearing.id, refresh: true)

      Hearing.recheck_index

      expect(case_numbers).to eq(['1C/1/2026'])
    end

    it 'leaves an index missing no records as it is' do
      hearing = create(:hearing)

      expect { Hearing.recheck_index }.not_to(change { version(Hearing, hearing) })
    end

    it 'raises naming the document Elasticsearch rejects' do
      court = create(:court)
      create_list(:court_expense, 2, court:, value: 2_000_000_000)
      Court.client.delete(index: Court.index_name, id: court.id, refresh: true)

      expect { Court.recheck_index }.to raise_error(
        Probe::IndexError,
        %r{\A#{Court.index_name}/#{court.id}: .*expenses.*out of range}
      )
    end
  end

  describe '.consolidate_index' do
    it 'deletes the documents of records no longer in the database' do
      create(:hearing, case_number: '1C/1/2026')
      gone = create(:hearing, case_number: '2C/1/2026')
      gone.delete
      refresh_indices

      Hearing.consolidate_index
      refresh_indices

      expect(Hearing.search({}).total_count).to eq(1)
      expect(case_numbers).to eq(['1C/1/2026'])
    end

    it 'keeps every document while its record exists' do
      create(:hearing, case_number: '1C/1/2026')
      refresh_indices

      Hearing.consolidate_index
      refresh_indices

      expect(case_numbers).to eq(['1C/1/2026'])
    end

    context 'without an index' do
      after { Hearing.ensure_index }

      it 'fails with the error of the missing index' do
        Hearing.delete_index

        expect { Hearing.consolidate_index }.to raise_error(Elastic::Transport::Transport::Errors::NotFound)
      end
    end
  end

  describe '.reindex' do
    it 'replaces an index of its name that is not an alias, as the Rails 3.2 app built them' do
      create(:court, name: 'Okresný súd Košice I')
      Court.delete_index
      Court.client.indices.create(index: Court.index_name)

      Court.reindex
      refresh_indices

      expect(Court.client.indices.exists_alias?(name: Court.index_name)).to be(true)
      expect(Court.search({}).records.map(&:name)).to eq(['Okresný súd Košice I'])
    end
  end

  describe '#remove_from_index' do
    it 'deletes a record missing from the index without reporting an error' do
      court = create(:court)
      Court.client.delete(index: Court.index_name, id: court.id, refresh: true)

      expect(reported_errors { court.destroy! }).to be_empty
    end
  end
end
