module NrsrSk
  module Base
    include Core::Base

    def source
      @source ||= Source.find_by_module self.name
    end
  end
end
