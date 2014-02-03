module Hearing::Scoped
  extend ActiveSupport::Concern

  def self.to(type)
    ClassMethods.type = type
    self
  end

  module ClassMethods
    def self.type=(type)
      raise unless type.is_a? HearingType
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
