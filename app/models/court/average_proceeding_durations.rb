module Court::AverageProceedingDurations
  extend ActiveSupport::Concern

  def average_proceeding_durations
    return @agendas if @agendas

    data = Loader.load(self.name)

    @agendas = data ? Agendas.new(data) : nil
  end

  module Loader
    extend self

    def load(name)
      data[name]
    end

    private

    def data
      @data ||= JSON.parse File.read(File.join Rails.root, 'data', 'court_average_proceeding_durations.json')
    end
  end

  module Ranking
    extend self

    def courts
      @courts ||= Court.by_type CourtType.district
    end

    def rank(court, acronym)
      ranking[acronym.to_sym].descending[court]
    end

    def rank_with_order(court, acronym)
      ranking[acronym.to_sym].rank_with_order(court)
    end

    private

    def ranking
      @raking ||= build_ranking
    end

    def build_ranking
      results = Hash.new

      [:T, :C, :Cb, :P].each do |acronym|
        results[acronym] = Resource::Ranking.new(courts.select(&:average_proceeding_durations)) { |court| court.average_proceeding_durations.by_acronym(acronym).data.map { |e| e[:value].to_f }.sum }
      end

      results
    end
  end

  class Agendas
    include Enumerable

    def initialize(data)
      @agendas  = Hash.new
      @acronyms = Hash.new

      data.each do |e|
        e.symbolize_keys!

        name    = e[:name]
        acronym = e[:acronym].to_sym

        @agendas[name] ||= Agenda.new name, acronym

        @agendas[name].data << e
        @agendas[name].data.sort! { |a, b| b[:year] <=> a[:year] }

        @acronyms[acronym] = name
      end
    end

    def each
      @agendas.values.each { |agenda| yield agenda }
    end

    def by_acronym(acronym)
      @agendas[@acronyms[acronym.to_sym]]
    end
  end

  class Agenda < Struct.new :name, :acronym
    def data
      @data ||= Array.new
    end
  end
end
