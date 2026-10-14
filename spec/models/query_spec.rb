# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Query do
  describe '#value' do
    it 'stores an empty search' do
      query = build(:query, value: {})

      expect(query).to be_valid
      expect(query.value).to eq({})
    end

    it 'stores a range as the form the facets read back' do
      query = build(:query, value: { range: 1..100 })

      expect(query).to be_valid
      expect(query.value).to eq(range: '1..100')
    end

    it 'stores a list of values' do
      query = build(:query, value: { court: %w[1 2] })

      expect(query.value).to eq(court: %w[1 2])
    end

    it 'stores a list of ranges' do
      query = build(:query, value: { range: [1..100, 2..300] })

      expect(query.value).to eq(range: %w[1..100 2..300])
    end
  end

  describe '.by_model_and_value' do
    it 'finds the same search by its digest' do
      query = create(:query, value: { court: ['Okresný súd Košice I'] })

      expect(described_class.by_model_and_value(Decree, { court: ['Okresný súd Košice I'] })).to eq([query])
      expect(described_class.by_model_and_value(Hearing, { court: ['Okresný súd Košice I'] })).to be_empty
    end
  end

  describe '.wrap' do
    it 'reads a search stored as JSON' do
      expect(described_class.wrap('{"court":["Okresný súd Košice I"]}')).to eq(court: ['Okresný súd Košice I'])
    end

    it 'keeps a search already read' do
      value = { court: ['Okresný súd Košice I'] }

      expect(described_class.wrap(value)).to be(value)
    end
  end

  it 'saves searches of decrees and hearings only' do
    expect(build(:query, model: 'User')).not_to be_valid
  end
end
