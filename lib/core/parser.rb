module Core
  module Parser
    def parse(content, options = {})
      clear if self.respond_to? :clear
      
      print "Parsing content ... "
      
      document = yield content
      
      puts "done"
      
      document
    end
  end
end
