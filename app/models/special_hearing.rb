class SpecialHearing < Hearing
  include Hearing::Scoped.to HearingType.special
  default_scope apply
end
