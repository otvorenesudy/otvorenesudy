module JusticeGovSk
  module Jobs
    class CrawlerJob
      @queue = :crawlers

      def self.perform(type, url)
        type = type.camelcase

        persistor  = Persistor.new
        downloader = Downloader.new
        storage    = "JusticeGovSk::Storages::#{type}Storage".constantize.new
        
        downloader.headers              = JusticeGovSk::Requests::URL.headers
        downloader.data                 = {}
        downloader.cache_load_and_store = true
        downloader.cache_root           = storage.root
        downloader.cache_binary         = storage.binary
        downloader.cache_distribute     = storage.distribute
        downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :html

        crawler = "JusticeGovSk::Crawlers::#{type}Crawler".constantize.new downloader, persistor

        crawler.crawl url
      end
    end
  end
end
