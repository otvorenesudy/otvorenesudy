# frozen_string_literal: true

# Average proceeding durations per agenda and year for district and municipal courts, from
# data/court_average_proceeding_durations.json, and the courts' ranking by them.
class Court
  module AverageProceedingDurations
    extend ActiveSupport::Concern

    def average_proceeding_durations
      data = Loader.load(name)

      Agendas.new(data) if data
    end

    module Loader
      module_function

      def load(name)
        data[name]
      end

      def data
        @data ||= JSON.parse(Rails.root.join('data/court_average_proceeding_durations.json').read)
      end
    end

    module Ranking
      module_function

      def courts
        Court.by_type([CourtType.district, CourtType.municipal])
      end

      def rank(court, acronym)
        ranking(acronym).descending[court.id]
      end

      def rank_with_order(court, acronym)
        ranking(acronym).rank_with_order(court.id)
      end

      # By the sum of the agenda's yearly averages; courts without data for the agenda aren't ranked.
      def ranking(acronym)
        durations = courts.filter_map do |court|
          data = Loader.load(court.name)
          agenda = Agendas.new(data).by_acronym(acronym) if data

          [court.id, agenda] if agenda
        end.to_h

        Resource::Ranking.new(durations.keys) { |id| durations[id].data.sum { |entry| entry[:value].to_f } }
      end
    end

    class Agendas
      include Enumerable

      def initialize(data)
        @agendas = {}
        @acronyms = {}

        data.each do |entry|
          entry = entry.symbolize_keys
          name = entry[:name]

          @agendas[name] ||= Agenda.new(name, entry[:acronym].to_sym)
          @agendas[name].data << entry
          @acronyms[entry[:acronym].to_sym] = name
        end

        @agendas.each_value { |agenda| agenda.data.sort_by! { |entry| entry[:year] }.reverse! }
      end

      def each(&)
        @agendas.each_value(&)
      end

      def by_acronym(acronym)
        @agendas[@acronyms[acronym.to_sym]]
      end
    end

    Agenda = Struct.new(:name, :acronym) do
      def data
        @data ||= []
      end
    end
  end
end
