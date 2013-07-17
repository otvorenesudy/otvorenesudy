module Court::AverageProceedingLengths
  extend ActiveSupport::Concern
  
  def average_proceeding_lengths
    @agendas ||= Agendas.new(Loader.data[self.name])
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
        e.symbolize_keys!

        name    = e[:name]
        acronym = e[:acronym].to_sym

        @results[name] ||= Agenda.new(name, acronym)

        @results[name].data << e
      end
    end

    def each
      @results.values.each { |agenda| yield agenda }
    end
  end

  class Agenda < Struct.new(:name, :acronym)
    def data
      @data ||= Array.new
    end
  end
end
