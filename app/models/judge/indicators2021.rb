class Judge
  module Indicators2021
    extend ActiveSupport::Concern
      
    included do
      Judge::Indicators2021.load!
    end

    def indicators_2021
      Judge::Indicators2021.for(self)
    end

    def self.for(judge)
      @data[judge.id]
    end

    def self.load!
      @data = Hash.new
      normalize = ->(value, max) {
        (value.to_f / max.to_f) * 10
      }

      CSV.read(Rails.root.join('data', 'judge-indicators-2021.csv'), col_sep: ',', headers: true).each do |line|
        judge = Judge.find_by_id(line[0])
      
        next unless judge

        @data[judge.id] = line
      end

      CSV.read(Rails.root.join('data', 'judge-indicators-2021-numerical.csv'), col_sep: ',', headers: true).each do |line|
        judge = Judge.find_by_id(line[0])
      
        next unless judge && @data[judge.id]

        @data[judge.id][:chart] = {
          availability: line['Dispozičný čas'],
          ratio: line['Vybavenosť'],
          approved_appeals: line['Potvrdené odvolania'],
          productivity: line['Produktivita'],
          arrears: line['Restančné z nevybavených']
        }
      end
    end

    def self.chart_bounds
      @chart_bounds ||= {
        arrears: @data.map { |_, e| e['Reštančné z nevybavených (%)'].to_f }.max,
        availability: @data.map { |_, e| e['Odhadovaná priemerná dĺžka konania (dispozičný čas - dni)'].to_f }.max,
        ratio: @data.map { |_, e| e['Vybavenosť (%)'].to_f }.max,
        decrees_approved: @data.map { |_, e| e['Počet potvrdených rozhodnutí'].to_f }.max,
        weighted_product: @data.map { |_, e| e['Vážené rozhodnuté'].to_f }.max,
      }
    end
  end
end
