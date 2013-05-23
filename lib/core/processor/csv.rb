require 'csv'

module Core
  module Processor
    module CSV
      include Core::Output

      def read(path, options = {})
        puts "Processing #{path} as csv ..."

        settings = Hash.new

        settings[:col_sep] = options[:separator] || ','
        settings[:headers] = options[:headers]   || :first_row

        lines = 0

        @file = File.basename(path)

        ::CSV.foreach(path, settings) do |line|
          yield line if block_given?

          lines += 1
        end

        puts "done (#{lines} lines read)"
      end

    end
  end
end
