# encoding: utf-8

module JusticeGovSk
  module Helpers
    module CrawlerHelper
      # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.crawl_resources(type, options = {})
        lister, request = build_lister_and_request type, options
        
        run_lister lister, request, options
      end
      
      # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.crawl_resource(type, url, options = {})
        crawler = build_crawler type, options
        
        run_crawler crawler, url, options
      end
      
      # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.build_lister_and_request(type, options = {})
        type = type.is_a?(Class) ? type : type.to_s.camelcase.constantize

        raise "Unsupported type #{type}" unless [Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree].include? type
        
        agent = JusticeGovSk::Agents::ListAgent.new
        
        agent.cache_load_and_store = false

        request = "JusticeGovSk::Requests::#{type.name}ListRequest".constantize.new
        
        if type == Judge
          persistor = Persistor.new
          
          lister = JusticeGovSk::Crawlers::JudgeListCrawler.new agent, persistor
        else
          request.decree_form = options[:decree_form] if type == Decree 
          
          lister = JusticeGovSk::Crawlers::ListCrawler.new agent
        end
        
        return lister, request
      end

      # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.build_crawler(type, options = {})
        type = type.is_a?(Class) ? type : type.to_s.camelcase.constantize

        raise "Unsupported type #{type}" unless [Court, CivilHearing, SpecialHearing, CriminalHearing, Decree].include? type

        storage = "JusticeGovSk::Storages::#{type.name}Storage".constantize.new

        downloader = Downloader.new

        downloader.headers              = JusticeGovSk::Requests::URL.headers
        downloader.data                 = {}
        downloader.cache_load_and_store = true
        downloader.cache_root           = storage.root
        downloader.cache_binary         = storage.binary
        downloader.cache_distribute     = storage.distribute
        downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :html

        persistor = Persistor.new

        crawler = "JusticeGovSk::Crawlers::#{type.name}Crawler".constantize.new downloader, persistor
        
        crawler.form_code = options[:decree_form] if type == Decree
        
        crawler
      end      
      
      def self.run_lister(lister, request, options = {}, &block)
        offset = options[:offset].blank? ? 1 : options[:offset].to_i
        limit  = options[:limit].blank? ? nil : options[:limit].to_i
        
        _, type = *request.class.name.match(/JusticeGovSk::Requests::(.+)ListRequest/)
        
        type = type.constantize
        
        if type == Judge
          raise "#{lister.class.name}: unable to use block" if block_given?

          block = lambda do
            lister.crawl_and_process(request, offset, limit)
          end
        else
          unless block_given?
            crawler = build_crawler type, options
            
            block = lambda do
              lister.crawl_and_process(request, offset, limit) do |url|
                run_crawler crawler, url, options
              end
            end
          end
        end
        
        block_call block, options
      end
      
      def self.run_crawler(crawler, url, options = {}, &block)
        block = lambda { crawler.crawl url } unless block_given?

        block_call block, options
      end
      
      def self.block_call(block, options = {})
        safe = options[:safe].nil? ? true : options[:safe]
        
        if safe
          block.call
        else
          begin
            block.call
          rescue Exception => e
            _, code = *e.to_s.match(/response code (\d+)/i)
            
            case code.to_i
            when 302
              puts "Redirect returned, rejected."
            when 500
              puts "Internal server error, rejected."
            else
              raise e
            end
          end
        end
      end
    end
  end
end
