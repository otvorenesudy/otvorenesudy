module Core
  module Factories
    def method_missing(method, *args, &block)
      name  = method.to_s
      match = name.match(/(?<type>((?!(by))[a-zA-Z0-9]+\_?)+)(\_by\_(?<data>.+))?_factory/)
      
      unless match.nil?
        type = match[:type].camelcase.constantize
        find = "find_by_#{match[:data]}" unless match[:data].nil?
        key  = "#{type}#{find}"
        
        block ||= lambda { |*a| type.send(find, *a) } unless find.blank?
  
        @factories = {} if @factories.nil?
        
        @factories[key] ||= Core::Factory::Supplier.instance.get type, block
        
        @factories[key].verbose = verbose
        
        @factories[key]
      else
        super method, *args, block
      end
    end
  end  
end
