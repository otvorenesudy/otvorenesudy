class CivilHearing < Hearing
  include Hearing::Scoped.to HearingType.civil

  default_scope apply

  storage :resource, JusticeGovSk::Storage::CivilHearingPage, extension: :html
end
