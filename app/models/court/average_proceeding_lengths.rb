module Court::AverageProceedingLengths
  def average_proceeding_lengths
    Agends.new(Loader.data[self.name])
  end

  class Loader
    def self.data
      @data ||= JSON.parse(File.read(File.join(Rails.root, 'data', 'court_average_proceeding_length.json')))
    end
  end

  class Agends
    include Enumerable

    def initialize(data)
      @results = Hash.new

      data.each do |e|
        e = e.symbolize_keys

        agend = e[:agend]

        @results[agend] = Agend.new(e[:agend], e[:agend_acronym]) unless @results[agend]

        @results[agend].values << e
      end
    end

    def each
      @results.values.each { |agend| yield agend }
    end
  end

  class Agend < Struct.new(:name, :acronym)
    def values
      @values ||= Array.new
    end
  end
end
