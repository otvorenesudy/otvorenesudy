module Type::Enumerable
  extend ActiveSupport::Concern

  module ClassMethods
    def value(name, value)
      define_singleton_method name do
        @values = {} unless @values
        @values[name] ||= self.find_or_create_by_value(value)
      end
    end
  end
end
