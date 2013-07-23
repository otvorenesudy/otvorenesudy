module Resource::Serialization
  extend ActiveSupport::Concern

  module ClassMethods
    def serialize_as_json(value)
      prepare_serialized_value(value).to_json
    end

    private

    def prepare_serialized_value(value)
      case value
      when String then value
      when Range  then value.to_s
      when Array  then value.map! { |v| prepare_serialized_value(v) }
      when Hash   then value.each { |k, v| value[k] = prepare_serialized_value(v) }
      else value  
      end
    end
  end
end
