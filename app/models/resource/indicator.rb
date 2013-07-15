module Resource::Indicator
  extend ActiveSupport::Concern

  module ClassMethods
    def indicators
      @indicators ||= Hash.new
    end

    def invalidate_indicators!
      indicators.each do |_, values|
        values.clear
      end
    end

    protected

    def indicate(indicator, options = {})
      name      = options[:method] || indicator.name.split(/::/).last.underscore.to_sym
      attribute = options[:attribute] || :id

      indicators[name] ||= Hash.new

      self.class_eval do
        include indicator

        alias_method "memoized_#{name}".to_sym, name.to_sym

        define_method name.to_sym do
          self.class.indicators[name][self.read_attribute(attribute)] ||= send("memoized_#{name}".to_sym)
        end

        alias_method "#{name}?".to_sym, name.to_sym
      end
    end
  end
end
