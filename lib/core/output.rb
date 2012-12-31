module Core
  module Output
    attr_accessor :verbose
    
    alias :default_print :print
    alias :default_puts  :puts
    
    def verbose=(value)
      @verbose = (value == true)
    end
    
    def verbose
      @verbose.nil? ? Core::Configuration.verbose : @verbose
    end
  
    def puts(*args)
      default_puts(*args) if verbose
    end
  
    def print(*args)
      default_print(*args) if verbose
    end
  end  
end
