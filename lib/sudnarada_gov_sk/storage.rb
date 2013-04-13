module SudnaradaGovSk
  class Storage
    include Singleton
    
    include Core::Storage
    
    def root
      @root ||= SudnaradaGovSk::Configuration.storage.root
    end
  end
end
