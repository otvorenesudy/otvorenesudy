# frozen_string_literal: true

require 'csv'

class Judge
  # Judges' performance indicators published for 2013, 2015 and 2017 (data/): a statistical table (agendas, courts,
  # ranks) and a numerical one (scores from 1 to 10) per year. Loaded on first use, then kept for the process.
  module Indicators
    Entry = Struct.new(:statistical, :numerical)

    class Dataset
      attr_reader :chart_columns

      # files: the statistical and numerical CSV; judge: :name or :id, what the judge column holds;
      # numerical_columns: the score columns (others become nil); chart_columns: the scores the radar chart shows.
      # The block normalizes a statistical value given its header.
      def initialize(files:, separator:, judge:, numerical_columns:, chart_columns:, &normalize)
        @files = files
        @separator = separator
        @judge = judge
        @numerical_columns = numerical_columns
        @chart_columns = chart_columns
        @normalize = normalize
      end

      def for(judge)
        data[judge.id]
      end

      def numerical_values_for(judge)
        self.for(judge)&.numerical&.[](chart_columns)
      end

      def complete?(judge)
        entry = self.for(judge)

        entry&.statistical.present? && entry.numerical.present?
      end

      # The agenda with the most cases; agendas maps each agenda to its statistical column.
      def dominant_agenda(judge, agendas)
        statistical = self.for(judge)&.statistical

        return unless statistical

        agendas.transform_values { |column| statistical[column].to_i }.max_by { |_, count| count }.first
      end

      # Each score's average over the judges in the data, to one decimal.
      def numerical_average
        @numerical_average ||= begin
          totals = Hash.new(0)

          data.each_value do |entry|
            entry.numerical&.each { |key, value| totals[key] += value if value }
          end

          totals.transform_values { |total| (total / data.size.to_f).round(1) }
        end
      end

      def data
        @data ||= load
      end

      def reset!
        @data = @numerical_average = nil
      end

      private

      def load
        courts = Court.all.index_by(&:name)
        entries = Hash.new { |hash, id| hash[id] = Entry.new }

        each_judge_row(:statistical) { |id, row| entries[id].statistical = normalize_statistical(row, courts) }
        each_judge_row(:numerical) { |id, row| entries[id].numerical = normalize_numerical(row) }

        entries.tap { |hash| hash.default_proc = nil }
      end

      def each_judge_row(kind)
        rows = CSV.read(Rails.root.join('data', @files.fetch(kind)), col_sep: @separator, headers: true)
        ids = judge_ids(rows.map { |row| judge_key(row) })

        rows.each do |row|
          id = ids[judge_key(row)]
          yield id, row if id
        end
      end

      def judge_key(row)
        (@judge == :name ? row[0] : row[1]).to_s.strip
      end

      def judge_ids(keys)
        return Judge.where(name: keys).pluck(:name, :id).to_h if @judge == :name

        Judge.where(id: keys).pluck(:id).index_by(&:to_s)
      end

      def normalize_statistical(row, courts)
        row.each { |key, value| row[key] = @normalize.call(key, value, courts) if value }
      end

      def normalize_numerical(row)
        row.each_with_index { |(key, value), index| row[key] = @numerical_columns.cover?(index) ? value.to_i : nil }
      end
    end

    def self.court(name, courts)
      courts[NameNormalizer.court_name(name)]
    end
  end
end
