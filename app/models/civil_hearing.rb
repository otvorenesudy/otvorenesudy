# encoding: utf-8

class CivilHearing < Hearing
  include Hearing::Scoped.to('Civilné')
  default_scope Hearing::Scoped.apply
end
