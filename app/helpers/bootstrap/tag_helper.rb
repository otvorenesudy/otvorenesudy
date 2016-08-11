module Bootstrap
  module TagHelper
    def data_attributes(attributes = {})
      attributes.inject({}) { |a, (k, v)| a["data-#{k}"] = v; a }
    end
  end
end
