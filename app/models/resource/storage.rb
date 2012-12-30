# TODO rm or refactor
module Resource::Storage
  extend ActiveSupport::Concern
  
  def self.use(type)
    ClassMethods.storage = type.new
    self
  end
  
  module ClassMethods
    def self.storage=(storage)
      @@storage = storage
    end

    def self.storage
      @@storage
    end
    
    def storage
      @@storage
    end
  end

  module InstanceMethods
    def path
      ClassMethods.storage.fullpath JusticeGovSk::Requests::URL.url_to_path(uri)
    end
  end  
end
