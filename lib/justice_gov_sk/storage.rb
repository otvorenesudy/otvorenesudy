module JusticeGovSk
  class Storage
    include Singleton

    include Core::Storage

    def root
      @root ||= JusticeGovSk::Configuration.storage.root
    end
  end
end
