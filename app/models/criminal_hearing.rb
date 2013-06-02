class CriminalHearing < Hearing
  include Hearing::Scoped.to HearingType.criminal
  
  default_scope apply
  
  storage :resource, JusticeGovSk::Storage::CriminalHearingPage, extension: :html
end
