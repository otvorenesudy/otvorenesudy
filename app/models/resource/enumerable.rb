module Resource::Enumerable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :values

    def load_values!
      values.inject({}) do |data, (name, instance)|
        data[name] = load_value(name, instance.value)
        data
      end
    end

    def save_values!
      values.each { |_, instance| instance.save! }
    end

    protected

    def value(name, value)
      name = name.to_sym

      @values       ||= {}
      @values[name] ||= load_value(name, value)

      define_singleton_method name do
        @values[name]
      end
    end
    
    private
    
    def load_value(name, value)
      attributes = { value: value }
      attributes[:name] = name.to_s if self.column_names.include? 'name'

      self.where(attributes).first_or_create!
    end
  end

  def name
    read_attribute(:name) || self.class.values.invert[self]
  end
end
