module Core
  module Parser
    def parse(content)
      print "Parsing content ... "
      
      document = yield content
      
      puts "done"
      
      document
    end
  end
end
