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
          @procedure.court  = court_by_name_factory.find(@parser.organization_name(@document))

          @procedure.declaration_url = @parser.declaration_url(@document)
          @procedure.report_url = @parser.report_url(@document)

          @procedure.organization_name = @parser.organization_name(@document)
          @procedure.organization_name_unprocessed = @parser.organization_name_unprocessed(@document)
          @procedure.organization_description = @parser.organization_description(@document)
          @procedure.date = @parser.date(@document)
          @procedure.description = @parser.description(@document)
          @procedure.place = @parser.place(@document)
          @procedure.position = @parser.position(@document)
          @procedure.state = @parser.state(@document)
          @procedure.workplace = @parser.workplace(@document)
          @procedure.closed_at = @parser.closed_at(@document)

          @persistor.persist(@procedure)

          @parser.commissioners(@document).each do |commissioner|
            commission = selection_procedure_commissioner_by_name_and_selection_procedure_id_factory.find_or_create(commissioner[:name], @procedure.id)

            commission.name = commissioner[:name]
            commission.name_unprocessed = commissioner[:unprocessed]
            commission.judge = judge_by_name_factory.find(commissioner[:name])
            commission.procedure = @procedure

            @persistor.persist(commission)
          end

          @parser.candidates_urls(@document).each do |url|
            JusticeGovSk.crawl_resource SelectionProcedureCandidate, url, safe: true, procedure: @procedure
          end

          download_url :declaration_url
          download_url :report_url

          @procedure
        end
      end

      def download_url(name)
        return if @procedure.read_attribute(name).blank?

        downloader = inject JusticeGovSk::Downloader, implementation: SelectionProcedure, suffix: :Document

        downloader.uri_to_path = lambda { |_| "#{@procedure.uri.match(/Ic=(\d+)/)[1]}_#{name.to_s.sub(/_url\Z/, '')}.pdf" }

        downloader.download @procedure.read_attribute(name)
      end
    end
  end
end
