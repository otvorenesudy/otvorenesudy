class CivilHearing < Hearing
  include Hearing::Scoped.to HearingType.civil

  default_scope apply

  storage :page, JusticeGovSk::Storage::CivilHearingPage, extension: :html
end
