module JusticeGovSk
  class Parser
    class StatisticalSummary
      include JusticeGovSk::Helper::Normalizer

      def parse(data)
        @data = data
      end

      def court
        court = @data[0].strip

        court_name_map[court.ascii.downcase] || court
      end

      private

      def value(data)
        data && data != 'NULL' ? data.squeeze(' ').strip : nil
      end

      def normalize(data)
        if data.is_a?(Hash)
          result = Hash.new

          data.each do |k, v|
            result[k] = value(v)
          end

          result
        else
          value(data)
        end
      end

      def filter(data)
        if data.is_a?(Hash)
          Hash[data.find_all { |_, v| v }]
        end
      end

      def normalize_and_filter(data)
        filter normalize(data)
      end
    end
  end
end
