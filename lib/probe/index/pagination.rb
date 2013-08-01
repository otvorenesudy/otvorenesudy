class Probe::Index
  module Pagination
    attr_reader :per_page

    def per_page
      @per_page ||= base.respond_to?(:default_per_page) ? base.default_per_page : Probe::Configuration.per_page
    end

    def paginate(collection, options = {})
      options[:page]     ||= 1
      options[:per_page] ||= 1000

      options[:page] -= 1

      collection.offset(options[:per_page] * options[:page]).limit(options[:per_page])
    end
  end
end
