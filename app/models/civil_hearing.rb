# frozen_string_literal: true

class CivilHearing < Hearing
  include Hearing::Scoped

  scoped_to :civil
end
