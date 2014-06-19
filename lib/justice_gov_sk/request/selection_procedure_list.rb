module JusticeGovSk
  class Request
    class SelectionProcedureList < JusticeGovSk::Request::List
      def self.url
        @url ||= "#{super}/Stranky/Ministerstvo/Vyberove-konania-v-rezorte/Zoznam-vyberovych-konani.aspx"
      end
    end
  end
end
