module Core
  module Extractor
    module Text
      include Core::Extractor
      include Core::Extractor::Cache

      def extract(path, options = {})
        options = extract_defaults.merge options

        super do
          dir = File.join root, File.basename(path)

          Docsplit.extract_text path, options.merge(output: dir)

          pages = {}

          Dir["#{dir}/*.txt"].each do |entry|
            number = entry[/_(\d+)\.txt/, 1].try(:to_i)
            text   = File.read(entry).gsub(/\f\z/, '')

            pages[number] = text unless text.blank?
          end

          FileUtils.remove_entry dir

          pages
        end
      end

      private

      def extract_defaults
        { subject: :text, unit: :page, pages: 'all', ocr: false }
      end
    end
  end
end
