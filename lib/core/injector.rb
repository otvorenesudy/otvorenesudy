module Core
  module Injector
    def inject(base, options = {})
      implementation = options[:implementation] || self.class
      
      instantiate(resolve(base, implementation, options))
    end
    
    private
    
    def resolve(base, implementation, options = {})
      base  = base.to_s.constantize
      
      words = []
      words << options[:prefix] unless options[:prefix].blank?
      words += implementation.to_s.split(/::/).last.split(/(?=[A-Z])/)
      words << options[:suffix] unless options[:suffix].blank?
      
      until words.empty? do
        name = words.join
        
        # TODO rm
        puts "NAME #{name}"
        
        begin
          # TODO rm
          puts "STMT #{base.const_get(name)} = #{base}.const_get(\"#{name}\")"
          
          constant = base.const_get(name)
          
          if constant.is_a?(Class) && constant.to_s.start_with?(base.to_s)
            return constant
          end
        rescue NameError
        end
        
        words = words[1..-1]
      end
      
      base
    end
    
    def instantiate(type, options = {})
      type.new
    end
  end
end
