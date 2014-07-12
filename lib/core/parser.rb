module Core
  module Parser
    def parse(content, options = {})
      clear

      print "Parsing content ... "

      document = yield content, options
      message  = options[:message]

      puts "#{document ? 'done' : 'failed'}#{message.blank? ? '' : " (#{message})"}"

      document
    end

    protected

    def clear
    end
  end
end
