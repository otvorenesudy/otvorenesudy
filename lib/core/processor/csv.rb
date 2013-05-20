require 'csv'

module Core
  module Processor
    module CSV
      include Core::Output

      def read(filename, options = {})
        puts "Processing #{filename} as csv ..."

        settings = Hash.new

        settings[:col_sep] = options[:separator] || ','
        settings[:headers] = options[:headers]   || :first_row

        lines = 0

        ::CSV.foreach(filename, settings) do |line|
          yield line if block_given?

          lines += 1
        end

        puts "done (#{lines} lines read)"
      end

    end
  end
end
