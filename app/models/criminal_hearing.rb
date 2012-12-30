class CriminalHearing < Hearing
  include Hearing::Scoped.to HearingType.criminal
  default_scope apply
end
