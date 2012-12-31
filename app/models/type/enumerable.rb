module Type::Enumerable
  extend ActiveSupport::Concern

  module ClassMethods
    def value(name, value)
      define_singleton_method name do
        @values = {} unless @values
        
        unless @values[name]
          @values[name] = self.find_or_create_by_value(value)
          @values[name].save!
        end 

        @values[name]
      end
    end
  end
end
