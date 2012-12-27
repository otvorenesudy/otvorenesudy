# encoding: utf-8

class CriminalHearing < Hearing
  include Hearing::Scoped.to('Trestné')
  default_scope Hearing::Scoped.apply
end
