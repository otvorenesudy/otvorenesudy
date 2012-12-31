module JusticeGovSk
  class Storage
    include Core::Storage
    
    def root
      @root ||= JusticeGovSk::Configuration.storage
    end
  end
end
