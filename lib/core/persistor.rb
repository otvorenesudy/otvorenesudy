module Core
  module Persistor
    include Core::Identify
    include Core::Output
    
    def persist(instance)
      print "Persisting #{identify instance} ... "
      
      instance.save!    
      
      puts "done (#{identify instance})"
      
      instance
    end
  end  
end
