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
      
      define_methos "#{name}_entry" do
        if block_given?
          yield self
        else
          JusticeGovSk::URL.url_to_path(uri, options[:extension])
        end
      end
      
      define_method "#{name}_path" do
        entry = self.send("#{name}_entry")
        
        self.class.storages[name].path(entry) if entry 
      end
    end
  end
end
