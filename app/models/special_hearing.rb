# frozen_string_literal: true

class SpecialHearing < Hearing
  include Hearing::Scoped

  scoped_to :special
end
