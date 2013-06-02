class SpecialHearing < Hearing
  include Hearing::Scoped.to HearingType.special

  default_scope apply

  storage :resource, JusticeGovSk::Storage::SpecialHearingPage, extension: :html
end
