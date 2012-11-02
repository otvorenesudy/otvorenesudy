require 'active_support/inflector'

module Pluralize
  def pluralize(n, s)
    "#{n} #{s.pluralize n}"
  end
end
