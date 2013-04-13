module SudnaradaGovSk
  class Request
    class List < SudnaradaGovSk::Request
      include Core::Request::List
      
      def initialize(options = {})
        @per_page = options[:per_page] || 100
        @page     = options[:page]     || 1
      end
    end
  end
end
