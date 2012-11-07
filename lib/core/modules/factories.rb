module Factories
  include Output
  
  def method_missing(method, *args)
    name  = method.to_s
    match = name.match(/(?<type>((?!(by))[a-zA-Z0-9]+\_?)+)(\_by\_(?<data>.+))?_factory/)
    
    unless match.nil?
      type = match[:type].camelcase.constantize
      find = "find_by_#{match[:data]}" unless match[:data].nil?  

      @factories = {} if @factories.nil?
      
      @factories[type] ||= FactorySupplier.instance.get type, find
      
      @factories[type].verbose = verbose
      
      @factories[type]
    else
      super method, *args
    end
  end
end
