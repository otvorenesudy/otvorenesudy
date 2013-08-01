module Probe
  module Proxy
    extend ActiveSupport::Concern

    included do
      probe.setup

      unless instance_methods.include?(:to_indexed_json)
        def to_indexed_json
          probe.to_indexed_json
        end
      end

      unless public_methods.include?(:paginate)
        def self.paginate(options)
          probe.paginate(self, options)
        end
      end
    end

    def probe
      @probe ||= Record.new(self)
    end

    module ClassMethods
      def probe(&block)
        @probe ||= Index.new(self)

        if block_given?
          @probe.instance_eval(&block)
        end

        @probe
      end
    end
  end
end
