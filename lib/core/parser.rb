module Core
  module Parser
    def parse(content, options = {})
      clear if self.respond_to? :clear
      
      print "Parsing content ... "
      
      document = yield content, options
      message  = options[:message]
      
      puts "#{document ? 'done' : 'failed'}#{message.blank? ? '' : " (#{message})"}"
      
      document
    end
  end
end
