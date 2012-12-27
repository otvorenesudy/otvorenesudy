module Hearing::Scoped
  extend ActiveSupport::Concern
  
  def self.to(value)
    ClassMethods.type = HearingType.find_or_create_by_value(value)
    self
  end
  
  module ClassMethods
    def self.type=(type)
      @@type = type
    end
    
    def type
      @@type
    end
    
    private
    
    def apply
      { conditions: { hearing_type_id: @@type.id } }
    end
  end
end
