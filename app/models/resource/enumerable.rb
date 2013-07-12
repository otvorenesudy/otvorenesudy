module Resource::Enumerable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :values

    def value(name, value)
      @values ||= {}

      name = name.to_sym

      attributes = { value: value }
      attributes[:name] = name.to_s if self.column_names.include? 'name'

      unless @values[name]
        @values[name] = self.where(attributes).first_or_create
        @values[name].save!
      end

      define_singleton_method name do
        @values[name]
      end
    end
  end

  def name
    read_attribute(:name) || self.class.values.invert[self]
  end
end
