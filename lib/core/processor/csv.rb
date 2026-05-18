require 'csv'

module Core
  module Processor
    module CSV
      def read(filepath, options = {})
        settings = Hash.new

        settings[:col_sep] = options[:separator] || ','
        settings[:headers] = options[:headers]   || :first_row

        lines = 0

        @filepath = filepath
        @filename = File.basename(@filepath)

        ::CSV.foreach(@filepath, settings) do |line|
          yield line if block_given?

          lines += 1
        end

        lines
      end
    end
  end
end
