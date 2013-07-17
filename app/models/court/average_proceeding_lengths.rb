module Court::AverageProceedingLengths
  extend ActiveSupport::Concern
  
  def average_proceeding_lengths
    Agendas.new(Loader.data[self.name])
  end

  class Loader
    def self.data
      @data ||= JSON.parse(File.read(File.join(Rails.root, 'data', 'court_average_proceeding_lengths.json')))
    end
  end

  class Agendas
    include Enumerable

    def initialize(data)
      @results = Hash.new

      data.each do |e|
        e = e.symbolize_keys

        agenda = e[:agenda]

        @results[agenda] = Agenda.new(e[:agenda], e[:agenda_acronym]) unless @results[agenda]

        @results[agenda].values << e
      end
    end

    def each
      @results.values.each { |agenda| yield agenda }
    end
  end

  class Agenda < Struct.new(:name, :acronym)
    def values
      @values ||= Array.new
    end
  end
end
