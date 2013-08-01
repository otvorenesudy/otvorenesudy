class Probe::Index
  module Sort
    attr_reader :sort_fields

    def sort_by(*args)
      @sort_fields ||= Array.new

      @sort_fields += args
    end
  end
end
