# frozen_string_literal: true

class CriminalHearing < Hearing
  include Hearing::Scoped

  scoped_to :criminal
end
