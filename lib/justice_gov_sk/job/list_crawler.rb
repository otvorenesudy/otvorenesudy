module JusticeGovSk
  module Job
    class ListCrawler
      include JusticeGovSk::Worker
      include JusticeGovSk::Helper::UpdateController::Resource

      sidekiq_options queue: :listers

      # supported types: CivilHearing, SpecialHearing, CriminalHearing, Decree
      def perform(type, options = {})
        type = type.to_s.constantize

        options.symbolize_keys!

        raise "No offset" unless options[:offset]
        raise "No limit"  unless options[:limit]

        request, lister = JusticeGovSk.build_request_and_lister type, options

        JusticeGovSk.run_lister lister, request, options do
          begin
            lister.crawl(request, options[:offset], options[:limit]) do |url|
              next unless crawlable? type, url

              JusticeGovSk::Job::ResourceCrawler.perform_async(type.name, url, options.merge(queue: nil))
            end
          rescue Exception => e
            raise e unless options[:limit] > 1

            scope = { request: { params: [type, options] } }

            Rollbar.scope(scope).error(e, use_exception_level_filters: true)

            JusticeGovSk::Job::ListCrawler.perform_async(type.name, options.merge(offset: request.page))
          end
        end
      end
    end
  end
end
