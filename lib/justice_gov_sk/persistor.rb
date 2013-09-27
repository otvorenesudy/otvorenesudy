module JusticeGovSk
  class Persistor
    include Core::Persistor
    
    def persist(instance)
      update = instance.respond_to?(:update_index) && !instance.id.nil?
      
      super
      
      if update
        print "Updating index #{identify instance} ... "
        
        instance.update_index
        
        puts "done (#{identify instance})"
      end
      
      instance
    end
  end
end
