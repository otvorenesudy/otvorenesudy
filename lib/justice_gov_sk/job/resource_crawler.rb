module JusticeGovSk
  module Job
    class ResourceCrawler
      include JusticeGovSk::Worker

      sidekiq_options queue: :crawlers

      # supported types: CivilHearing, SpecialHearing, CriminalHearing, Decree
      def perform(type, url, options = {})
        require 'objspace'
        ObjectSpace.trace_object_allocations_start

        type = type.to_s.constantize

        options.symbolize_keys!

        JusticeGovSk.crawl_resource type, url, options
      end
    end
  end
end
