module Core
  module Parser
    module List
      include Core::Parser
      
      def list(document)
        []
      end
      
      def page(document)
      end
      
      def pages(document)
      end
      
      def per_page(document)
      end
    
      def next_page(document)
        k = page(document)
        n = pages(document)
        
        k + 1 if k && n && k < n
      end
    end
  end
end
