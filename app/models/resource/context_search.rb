module Resource::ContextSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def context_query
      define_method :context_query do
        return @context_query if @context_query  
        
        query   = yield self
        options = self.class.context_options if options.blank?
        
        query << " site:(#{options[:whitelist].join ' OR '})"                unless options[:whitelist].blank?
        query << " #{options[:blacklist].map { |e| "-site:#{e}" }.join ' '}" unless options[:blacklist].blank?
        
        @context_query = query  
      end
    end

    def context_options(options = {})
      @context_options ||= {
        whitelist: %w(sme.sk tyzden.sk webnoviny.sk tvnoviny.sk pravda.sk etrend.sk aktualne.sk),
        blacklist: %w(http://www.sme.sk/diskusie/ blog.sme.sk)
      }.merge options
    end
  end
  
  def context_search(options = {})
    @context_search       ||= Bing::Search.new
    @context_search.query   = options[:query]   || context_query
    @context_search.exclude = options[:exclude] || self.class.context_options[:exclude]
    @context_search.perform
  end
end
