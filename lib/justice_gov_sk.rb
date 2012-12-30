# encoding: utf-8

# TODO refactor all helpers to be not static, like in app/helpers

# TODO refactor core:
#
# do not mix variables:
# uri -> request
# content -> ? (resource?)
#
# remove subclass specific functionality from superclass,
# example: mv ListRequest.decree_form -> DecreeListRequest
# remove lines like: if type < Hearing

require 'justice_gov_sk/configuration'
require 'justice_gov_sk/url'
require 'justice_gov_sk/storage'
require 'justice_gov_sk/storage/page'
require 'justice_gov_sk/storage/court_page'
require 'justice_gov_sk/storage/hearing_page'
require 'justice_gov_sk/storage/civil_hearing_page'
require 'justice_gov_sk/storage/criminal_hearing_page'
require 'justice_gov_sk/storage/special_hearing_page'
require 'justice_gov_sk/storage/decree_page'
require 'justice_gov_sk/storage/document'
require 'justice_gov_sk/storage/decree_document'
require 'justice_gov_sk/request'
require 'justice_gov_sk/request/list'
require 'justice_gov_sk/request/court_list'
require 'justice_gov_sk/request/judge_list'
require 'justice_gov_sk/request/hearing_list'
require 'justice_gov_sk/request/civil_hearing_list'
require 'justice_gov_sk/request/criminal_hearing_list'
require 'justice_gov_sk/request/special_hearing_list'
require 'justice_gov_sk/request/decree_list'
require 'justice_gov_sk/request/document'
require 'justice_gov_sk/downloader'
require 'justice_gov_sk/agent'
require 'justice_gov_sk/agent/document'
require 'justice_gov_sk/agent/list'
require 'justice_gov_sk/normalizer'
require 'justice_gov_sk/parser'
require 'justice_gov_sk/parser/list'
require 'justice_gov_sk/parser/court'
require 'justice_gov_sk/parser/judge_list'
require 'justice_gov_sk/parser/hearing'
require 'justice_gov_sk/parser/civil_hearing'
require 'justice_gov_sk/parser/criminal_hearing'
require 'justice_gov_sk/parser/special_hearing'
require 'justice_gov_sk/parser/decree'
require 'justice_gov_sk/persistor'
require 'justice_gov_sk/crawler'
require 'justice_gov_sk/crawler/list'
require 'justice_gov_sk/crawler/court'
require 'justice_gov_sk/crawler/judge_list'
require 'justice_gov_sk/crawler/hearing'
require 'justice_gov_sk/crawler/civil_hearing'
require 'justice_gov_sk/crawler/criminal_hearing'
require 'justice_gov_sk/crawler/special_hearing'
require 'justice_gov_sk/crawler/decree'
require 'justice_gov_sk/job/crawler'
require 'justice_gov_sk/job/list_crawler'
require 'justice_gov_sk/version'

module JusticeGovSk
  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.crawl_resources(type, options = {})
    request, lister = build_request_and_lister type, options
    
    run_lister lister, request, options
  end
  
  # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.crawl_resource(type, url, options = {})
    crawler = build_crawler type, options
    
    run_crawler crawler, url, options
  end

  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.build_request(type, options = {})
    type = type.is_a?(Class) ? type : type.to_s.camelcase.constantize
    
    request = "JusticeGovSk::Request::#{type.name}List".constantize.new
    
    request.per_page = options[:per_page] unless options[:per_page].nil?
    request.page     = options[:page]     unless options[:page].nil? 
    
    if type < Hearing
      request.include_old_hearings = options[:include_old_hearings] unless options[:include_old_hearings].nil?
    elsif type < Decree
      request.decree_form = options[:decree_form] unless options[:decree_form].nil?
      
      raise "Unknown decree form #{request.decree_form}" unless DecreeForm.find_by_code(request.decree_form)
    end
    
    request
  end
  
  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.build_lister(type, options = {})
    type = type.is_a?(Class) ? type : type.to_s.camelcase.constantize unless type.nil?

    agent = JusticeGovSk::Agent::List.new
    
    agent.cache_load_and_store = false
    
    if options[:generic].blank?
      if type == Judge
        persistor = JusticeGovSk::Persistor.new
      
        return JusticeGovSk::Crawler::JudgeList.new agent, persistor
      end
    end
    
    JusticeGovSk::Crawler::List.new agent
  end
  
  # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.build_request_and_lister(type, options = {})
    request = build_request type, options
    lister  = build_lister  type, options
    
    return request, lister
  end
  
  # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
  def self.build_crawler(type, options = {})
    type = type.is_a?(Class) ? type : type.to_s.camelcase.constantize

    storage = "JusticeGovSk::Storage::#{type.name}Page".constantize.new

    downloader = Downloader.new

    downloader.headers              = JusticeGovSk::Request.headers
    downloader.data                 = {}
    downloader.cache_load_and_store = true
    downloader.cache_root           = storage.root
    downloader.cache_binary         = storage.binary
    downloader.cache_distribute     = storage.distribute
    downloader.cache_uri_to_path    = JusticeGovSk::URL.url_to_path_lambda :html

    persistor = Persistor.new

    crawler = "JusticeGovSk::Crawler::#{type.name}".constantize.new downloader, persistor
    
    crawler.form_code = options[:decree_form] if type == Decree
    
    crawler
  end      
  
  def self.run_lister(lister, request, options = {}, &block)
    offset = options[:offset].blank? ? 1 : options[:offset].to_i
    limit  = options[:limit].blank? ? nil : options[:limit].to_i
    
    _, type = *request.class.name.match(/JusticeGovSk::Request::(.+)List/)
    
    type = type.constantize

    if options[:generic].blank? && type == Judge
      raise "Unable to use block" if block_given?

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
