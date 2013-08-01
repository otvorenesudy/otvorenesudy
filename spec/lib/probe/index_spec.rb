require 'probe_spec_helper'

describe Probe::Index do
  after :each do
    Record.probe.delete
  end

  context 'when creating index' do
    before :all do
      Record.class_eval { include Probe }
    end


    it 'should create index with simple mapping' do
      Record.class_eval do
        probe do
          mapping do
            map     :id,     type: :long
            map     :number, type: :integer
            analyze :title,  boost: 10.0
            analyze :text
          end
        end
      end

      Record.probe.mapping.should eql({
        id:     { type: :long, index: :not_analyzed },
        number: { type: :integer, index: :not_analyzed },
        title:  { type: :multi_field, fields: {
          title: { type: :string, analyzer: Probe::Configuration.default_analyzer, boost: 10.0 },
          untouched: { type: :string, index: :not_analyzed }
          }
        },
        text:  { type: :multi_field, fields: {
          text: { type: :string, analyzer: Probe::Configuration.default_analyzer },
          untouched: { type: :string, index: :not_analyzed }
         }
        }
      })
      Record.probe.create.should be_true
    end

    it 'should create index settings' do
      options = { some_nifty_settings: { settings: true } }

      Record.class_eval do
        probe do
          settings options
        end
      end

      Record.probe.create.should   be_true
      Record.probe.settings.should eql(Probe::Configuration.index.deep_merge!(options))
    end

    it 'should update mapping' do
      fields = [:id, :title]

      Record.probe.mapping.clear

      Record.probe.mapping { fields.each { |f| map f } }
      Record.probe.mapping.should eql({
        id:    { type: :string, index: :not_analyzed },
        title: { type: :string, index: :not_analyzed }
      })

      Record.probe.create

      fields << :text

      Record.probe.update_mapping.should be_true
      Record.probe.mapping.should eql({
        id:    { type: :string, index: :not_analyzed },
        title: { type: :string, index: :not_analyzed },
        text:  { type: :string, index: :not_analyzed }
      })
    end

    it 'should delete index' do
      Record.probe.create
      Record.probe.exists?.should be_true

      Record.probe.delete
      Record.probe.exists?.should be_false
    end
  end

  context 'when defining facets' do
    it 'should define facets' do
      Record.class_eval do
        probe do
          facets do
            facet :terms, type: :terms
            facet :range, type: :range, ranges: [1..2]
          end
        end
      end

      Record.probe.facets.map(&:name).should eql([:terms, :range])
    end
  end

  context 'when populating index' do
    let!(:collection) { 10.times.map { build :record } }

    before :all do
      Record.class_eval { include Probe }

      Record.probe.mapping do
        map     :id,     type: :long
        map     :number, type: :integer
        analyze :title
        analyze :text
      end
    end

    before :each do
      Record.probe.create

      Record.collection = collection
    end

    it 'should import entire collection' do
      Record.probe.import

      Record.probe.total.should eql(collection.size)
    end

    it 'should update entire collection' do
      Record.probe.import

      Record.probe.update

      Record.probe.total.should eql(collection.size)
    end
  end
end
