module Core
  module Output
    attr_accessor :colored,
                  :verbose
    
    alias :default_print :print
    alias :default_puts  :puts
    
    def colored=(value)
      @colored = (value == true)
    end
    
    def colored
      @colored.nil? ? Core::Configuration.colors : @colored
    end
    
    def verbose=(value)
      @verbose = (value == true)
    end
    
    def verbose
      @verbose.nil? ? Core::Configuration.verbose : @verbose
    end
    
    def puts(*args)
      *args = colorize(args) if colored 
      default_puts(*args)    if verbose
    end
    
    def print(*args)
      *args = colorize(args) if colored
      default_print(*args)   if verbose
    end
    
    private
    
    def colorize(args)
      args.map do |arg|
        arg.gsub!(/^running/i)         { |s| s.bold       }
        arg.gsub!(/^finished/i)        { |s| s.green.bold }
       #arg.gsub!(/^\w+ing/)           { |s| s.underline  }
        arg.gsub!(/\w+(\:\:\w+)+/)     { |s| s.blue.bold  }
        arg.gsub!(/[a-z]+\:(\?|\d+)/i) { |s| s.bold       }
        arg.gsub!(/done/i)             { |s| s.green.bold }
        arg.gsub!(/failed/i)           { |s| s.red.bold   }
        arg
      end
    end
  end
end
