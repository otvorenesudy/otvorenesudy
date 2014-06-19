module JusticeGovSk
  class Crawler
    class SelectionProcedure < JusticeGovSk::Crawler
      def initialize(options = {})
        super(options)
      end

      protected

      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)

          @procedure = selection_procedure_by_uri_factory.find_or_create(uri)

          @procedure.uri    = uri
          @procedure.source = JusticeGovSk.source

          @procedure
        end
      end
    end
  end
end
