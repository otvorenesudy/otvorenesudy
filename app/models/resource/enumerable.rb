# frozen_string_literal: true

# Lookup tables with a fixed set of rows (court types, hearing types, periods): `value :district, 'Okresný'` defines
# `CourtType.district`, the row with that value, created if it's missing. Rows are looked up when first asked for, not
# while the class loads, and db/seeds.rb creates them all.
module Resource
  module Enumerable
    extend ActiveSupport::Concern

    class_methods do
      def values
        @values ||= {}
      end

      def save_values!
        values.each_key { |name| public_send(name) }
      end

      private

      def value(name, value)
        name = name.to_sym
        values[name] = value

        define_singleton_method(name) do
          attributes = { value: }
          attributes[:name] = name.to_s if column_names.include?('name')

          find_or_create_by!(attributes)
        end
      end
    end

    def name
      self[:name] || self.class.values.key(value)
    end
  end
end
