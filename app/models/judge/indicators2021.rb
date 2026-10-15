# frozen_string_literal: true

require 'csv'

class Judge
  # The 2021 judge evaluation (data/judge-indicators-2021*.csv): a row of results per judge and the scores of its chart.
  # Loaded on first use, then kept for the process.
  module Indicators2021
    extend ActiveSupport::Concern

    CHART_COLUMNS = {
      availability: 'Dispozičný čas',
      ratio: 'Vybavenosť',
      approved_appeals: 'Potvrdené odvolania',
      productivity: 'Produktivita',
      arrears: 'Restančné z nevybavených'
    }.freeze

    BOUND_COLUMNS = {
      arrears: 'Reštančné z nevybavených (%)',
      availability: 'Odhadovaná priemerná dĺžka konania (dispozičný čas - dni)',
      ratio: 'Vybavenosť (%)',
      decrees_approved: 'Počet potvrdených rozhodnutí',
      weighted_product: 'Vážené rozhodnuté'
    }.freeze

    def self.for(judge)
      data[judge.id]
    end

    def self.data
      @data ||= load
    end

    def self.reset!
      @data = @chart_bounds = nil
    end

    def self.chart_bounds
      @chart_bounds ||= BOUND_COLUMNS.transform_values do |column|
        data.values.map { |row| row[column].to_f }.max
      end
    end

    def self.load
      rows = read('judge-indicators-2021.csv')
      ids = Judge.where(id: rows.pluck(0)).ids.to_set
      data = rows.select { |row| ids.include?(row[0].to_i) }.index_by { |row| row[0].to_i }

      read('judge-indicators-2021-numerical.csv').each do |row|
        data[row[0].to_i][:chart] = CHART_COLUMNS.transform_values { |column| row[column] } if data.key?(row[0].to_i)
      end

      data
    end

    def self.read(file)
      CSV.read(Rails.root.join('data', file), col_sep: ',', headers: true)
    end

    private_class_method :load, :read

    def indicators_2021
      Judge::Indicators2021.for(self)
    end
  end
end
