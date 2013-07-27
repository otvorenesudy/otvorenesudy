require 'probe_spec_helper'

describe Probe::Index do
  let!(:collection) { 10.times.map { build :record } }

  before :each do
    Record.class_eval { include Probe::Index }
  end

  context 'when creating index' do
    it 'should create index with simple mapping' do
      Record.class_eval do
        probe do
          mapping do
            map     :id,     type: :long
            map     :number, type: :integer
            analyze :title
            analyze :text
          end
        end
      end

      Record.probe.mapping.should eql({
        id:     { type: :long, index: :not_analyzed },
        number: { type: :integer, index: :not_analyzed },
        title:  { type: :multi_field, fields: {
          analyzed: { type: :string, analyzer: Probe::Configuration.default_analyzer },
          untouched: { type: :string, index: :not_analyzed }
          }
        },
        text:  { type: :multi_field, fields: {
          analyzed: { type: :string, analyzer: Probe::Configuration.default_analyzer },
          untouched: { type: :string, index: :not_analyzed }
         }
        }
      })
    end

    it 'should create index settings' do
      options = { some_nifty_settings: { settings: true } }

      Record.class_eval do
        probe do
          settings options
        end
      end

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

      fields << :text

      Record.probe.index.should_receive(:put_mapping).and_return(true)

      Record.probe.update_mapping

      Record.probe.mapping.should eql({
        id:    { type: :string, index: :not_analyzed },
        title: { type: :string, index: :not_analyzed },
        text:  { type: :string, index: :not_analyzed }
      })
    end
  end
end
