require 'spec_helper'

describe Query do
  describe '#value' do
    it 'should create valid query for empty hash' do
      query = build :query, :empty

      query.should be_valid
      query.value.should eql({})
    end

    it 'should create valid query from hash with ranges' do
      query = build :query

      query.value = { range: 1..100 }

      query.should       be_valid
      query.value.should eql({ range: '1..100' })
    end

    it 'should create valid query from hash with arrays' do
      query = build :query

      query.value = { array: ['1', '2'] }

      query.should       be_valid
      query.value.should eql({ array: ['1', '2']})
    end

    it 'should create valie query from hash with range arrays' do
      query = build :query

      query.value = { range: [1..100, 2..300] }

      query.should       be_valid
      query.value.should eql({ range: ['1..100', '2..300'] })
    end
  end
end
