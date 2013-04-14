module SudnaradaGovSk
  class Request
    class List < SudnaradaGovSk::Request
      include Core::Request::List
      
      def initialize(options = {})
        @page = options[:page] || 1
      end
    end
  end
end
