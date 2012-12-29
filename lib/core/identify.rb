module Core
  module Identify
    def identify(o)
      "#{o.class.name}:#{o.id || '?'}"
    end
  end  
end
