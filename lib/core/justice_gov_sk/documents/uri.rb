module JusticeGovSk
  module Documents
    module URI
      def self.base
        @path ||= File.join Rails.root, 'public', 'documents'
      end
    end
  end
end
