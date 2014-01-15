module SudnaradaGovSk
  class Parser
    class List < SudnaradaGovSk::Parser
      include Core::Parser::List

      protected

      def clear
        @page  = nil
        @pages = nil
      end
    end
  end
end
