# frozen_string_literal: true

# An attribute composed from others when it isn't stored: `formatable :name, default: '%p %f %l, %s' do |judge| {...}`
# makes `judge.name` the stored name, or the name composed by the default pattern, and `judge.name('%f %l')` the name in
# another pattern. `fixes:` clean up the composed value (a trailing comma when the suffix is missing).
module Resource
  module Formatable
    extend ActiveSupport::Concern

    class_methods do
      def formatters
        @formatters ||= {}
      end

      private

      def formatable(attribute, options = {}, &)
        define_method(attribute) do |pattern = nil|
          value = self[attribute]

          return value if !value.nil? && (pattern.nil? || pattern == options[:default])

          formatter = (self.class.formatters[attribute] ||= Formatter.new(yield(self), options))
          cache = (formatted[attribute] ||= Cache.new(yield(self)))

          cache.get(formatter, pattern)
        end

        define_method("invalidate_#{attribute}") do
          formatted[attribute] = nil
        end
      end
    end

    class Formatter
      attr_reader :default, :directives, :fixes

      def initialize(data, options = {})
        @default = options[:default] || raise(ArgumentError, 'formatable needs a default pattern')
        @directives = data.keys.pluck(1)
        @fixes = Array.wrap(options[:fixes])
        @pattern = /%[#{@directives.join}]/
      end

      def format(pattern, data)
        value = (pattern || default).gsub(@pattern) { |directive| data[directive].to_s }.squeeze(' ').strip

        fixes.reduce(value) { |fixed, fix| fix.call(fixed) }
      end
    end

    class Cache
      def initialize(data)
        @data = data
        @cache = {}
      end

      def get(formatter, pattern)
        @cache[pattern] ||= formatter.format(pattern, @data)
      end
    end

    private

    def formatted
      @formatted ||= {}
    end
  end
end
