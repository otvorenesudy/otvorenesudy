module Core
  module Factories
    def method_missing(method, *args, &block)
      name  = method.to_s
      match = name.match(/(?<type>((?!(by))[a-zA-Z0-9]+\_?)+)(\_by\_(?<data>.+))?_factory/)

      unless match.nil?
        type = match[:type].camelcase.constantize
        find = "find_by_#{match[:data]}" unless match[:data].nil?

        @supplier ||= Core::Factory::Supplier.new

        @supplier.get type, find, verbose: verbose
      else
        super method, *args, block
      end
    end
  end
end
