# frozen_string_literal: true

# Includes an indicator module and memoizes its method per record id for the life of the process:
# `indicate Court::AverageProceedingDurations` makes `court.average_proceeding_durations` computed once per court.
module Resource
  module Indicator
    extend ActiveSupport::Concern

    class_methods do
      def indicators
        @indicators ||= {}
      end

      def invalidate_indicators!
        indicators.each_value(&:clear)
      end

      private

      def indicate(indicator, options = {})
        name = (options[:method] || indicator.name.demodulize.underscore).to_sym
        attribute = options[:attribute] || :id

        indicators[name] ||= {}

        include indicator

        alias_method :"memoized_#{name}", name

        define_method(name) do
          values = self.class.indicators[name]
          key = self[attribute]

          values.key?(key) ? values[key] : (values[key] = public_send(:"memoized_#{name}"))
        end

        alias_method :"#{name}?", name
      end
    end
  end
end
