module Factories
  def method_missing(method, *args)
    string = method.to_s
    
    if string =~ /(.+)_factory/
      type = string[0..-8].camelcase.constantize

      @factories = {} if @factories.nil?
      
      @factories[type] ||= FactorySupplier.instance.get type
    else
      super method, *args
    end
  end
end
