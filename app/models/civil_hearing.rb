class CivilHearing < Hearing
  include Hearing::Scoped.to HearingType.civil
  default_scope apply
end
