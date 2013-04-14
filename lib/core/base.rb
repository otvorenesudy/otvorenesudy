module Core
  module Base
    include Core::Output
    
    def crawl_resources(type, options = {})
      request, lister = build_request_and_lister type, options
      
      run_lister lister, request, options
    end
    
    def crawl_resource(type, url, options = {})
      crawler = build_crawler type, options
      
      run_crawler crawler, url, options
    end
  
    def build_request(type, options = {})
      args = build_args type, options
      base = build_base self, :Request
      
      inject base, implementation: type, suffix: :List, args: args
    end
    
    def build_lister(type, options = {})
      args = build_args type, options
      base = build_base self, :Crawler
      
      inject base, implementation: type, suffix: :List, args: args
    end
    
    def build_request_and_lister(type, options = {})
      request = build_request type, options
      lister  = build_lister  type, options

      return request, lister
    end
    
    def build_crawler(type, options = {})
      args = build_args type, options
      base = build_base self, :Crawler

      inject base, implementation: type, args: args
    end      
    
    def run_lister(lister, request, options = {}, &block)
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      block  = lambda { lister.crawl request, offset, limit } unless block_given?
      
      call block, options
    end
    
    def run_crawler(crawler, url, options = {}, &block)
      block = lambda { crawler.crawl url } unless block_given?
      
      call block, options
    end
    
    private
    
    include Core::Injector
    
    def build_args(type, options = {})
      options.to_hash.merge type: type
    end
    
    def build_base(base, type)
      root = [base, base.parents].flatten[-2]
      
      "#{root}::#{type}".constantize
    end
    
    def call(block, options = {})
      safe = options[:safe].nil? ? true : options[:safe]
      
      puts "Settings #{pack options}"
      
      if safe
        block.call
      else
        begin
          block.call
        rescue Exception => e
          _, code = *e.to_s.match(/response code (\d+)/i)
          
          case code.to_i
          when 302
            puts "aborted (redirect returned)"
          when 403
            puts "aborted (forbidden)"
          when 404
            puts "aborted (not found)"
          when 500
            puts "aborted (internal server error)"
          else
            raise e
          end
        end
      end
    end
    
    def pack(options = {})
      options.map { |k, v| "#{k}: #{v.is_a?(Class) ? v.name : v}" }.join(', ') || 'nothing'
    end
  end
end
