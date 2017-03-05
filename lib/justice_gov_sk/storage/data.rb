# TODO rm - unused?
module JusticeGovSk
  class Storage
    class Data < JusticeGovSk::Storage
      def root
        @root ||= File.join Rails.root, 'data'
      end
    end
  end
end
