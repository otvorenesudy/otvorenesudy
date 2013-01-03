module Resource::Storage
  extend ActiveSupport::Concern
  
  module ClassMethods
    def storages
      @storages || {}
    end

    def storage(name, type, options = {})
      @storages = {} unless @storages
      
      @storages[name] = type.instance unless @storages[name]
      
      define_method "#{name}_storage" do
        self.class.storages[name]
      end
      
      define_method "#{name}_path" do
        if block_given?
          path = yield self
        else
          path = JusticeGovSk::URL.url_to_path(uri, options[:extension])
        end
        
        self.class.storages[name].fullpath(path) if path 
      end
    end
  end
end
