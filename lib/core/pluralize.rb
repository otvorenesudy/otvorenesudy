module Core
  module Pluralize
    def pluralize(n, s)
      "#{n} #{s.pluralize n}"
    end
  end  
end
