# frozen_string_literal: true

# Saved search params as JSON: ranges become their "a..b" form, the form the facets read back.
module Resource
  module Serializable
    extend ActiveSupport::Concern

    class_methods do
      def serialize_as_json(value)
        prepare_serialized_value(value).to_json
      end

      private

      def prepare_serialized_value(value)
        case value
        when Range then value.to_s
        when Array then value.map { |item| prepare_serialized_value(item) }
        when Hash then value.transform_values { |item| prepare_serialized_value(item) }
        else value
        end
      end
    end
  end
end
