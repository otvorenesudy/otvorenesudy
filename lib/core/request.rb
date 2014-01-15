module Core
  module Request
    def self.uri(request)
      request.respond_to?(:uri) ? request.uri : request.to_s
    end

    def uri
      url if respond_to? :url
    end
  end
end
