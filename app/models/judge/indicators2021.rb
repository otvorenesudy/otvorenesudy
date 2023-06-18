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

      CSV.read(Rails.root.join('data', 'judge-indicators-2021.csv'), col_sep: ',', headers: true).each do |line|
        judge = Judge.find_by_id(line[0])

        next unless judge

        @data[judge.id] = line
      end
    end
  end
end
