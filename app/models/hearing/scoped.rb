module Hearing::Scoped
  extend ActiveSupport::Concern
  
  def self.to(value)
    @@hearing_type = HearingType.find_by_value(value)
    self
  end
  
  def self.apply
    { conditions: { hearing_type_id: @@hearing_type.id } }
  end
end
