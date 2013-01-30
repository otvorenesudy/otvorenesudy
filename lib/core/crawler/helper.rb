module Core
  module Crawler
    module Helper
      def supply(instance, name, attributes)
        map = {}
        
        attributes.each do |attribute|
          map[attribute] = @parser.send(attribute, @document)
        end
        
        o = yield(*map.values)
        
        unless value.nil?
          map.each do |k, v|
            o.send("#{k}=", v)
          end
          
          @persistor.persist(o)
          
          instance.send("#{name}=", o)
        end
      end
    end
  end
end
