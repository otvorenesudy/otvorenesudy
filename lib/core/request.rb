module Core
  module Request
    def uri
      url if respond_to? :url
    end
  end
end
