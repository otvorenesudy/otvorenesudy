module JusticeGovSk
  module Job
    class ListCrawler
      include JusticeGovSk::Worker
      include JusticeGovSk::Helper::UpdateController::Resource

      sidekiq_options queue: :listers

      # supported types: CivilHearing, SpecialHearing, CriminalHearing, Decree
      def perform(type, options = {})
        require 'objspace'
        ObjectSpace.trace_object_allocations_start

        type = type.to_s.constantize

        options.symbolize_keys!

        raise "No offset" unless options[:offset]
        raise "No limit"  unless options[:limit]

        request, lister = JusticeGovSk.build_request_and_lister type, options

        JusticeGovSk.run_lister lister, request, options do
          lister.crawl(request, options[:offset], options[:limit]) do |url|
            next unless crawlable? type, url

            JusticeGovSk::Job::ResourceCrawler.perform_async(type.name, url, options)
          end
        end
      end
    end
  end
end
