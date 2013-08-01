module Probe
  module Helpers
    def wrap_field(field)
      return :* if field.eql? :all

      return field.map { |f| f.to_sym } if field.is_a? Array

      return field
    end

    def create_facet(type, name, field, options)
      "Probe::Facets::#{type.to_s.camelcase}Facet".constantize.new(name,field, options)
    end
  end
end
