module JusticeGovSk
  module Injector
    def inject(base, implementation = self.class, options = {})
      type = resolve(base, implementation, options)
      
      instantiate(type)
    end
    
    private
    
    def resolve(base, implementation, options = {})
      base  = base.to_s.constantize
      words = implementation.to_s.split(/::/).last.split(/(?=[A-Z])/)
      
      (words.size + 1).times do
        name = "#{options[:prefix]}#{words.join}#{options[:suffix]}"
        
        return base if name.empty?
        
        begin
          constant = base.const_get(name)
          
          if constant.is_a?(Class) && constant.to_s.start_with?(base.to_s)
            return constant
          end
        rescue NameError
        end
        
        words = words[1..-1]
      end
      
      raise "Unable to resolve #{implementation}"
    end
    
    def instantiate(type, options = {})
      type.new
    end
  end
end
