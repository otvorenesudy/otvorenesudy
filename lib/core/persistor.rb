class Persistor
  include Identify
  
  def persist(instance)
    print "Persisting #{identify instance} ... "

    instance.save!    

    puts "done (#{identify instance})"
    
    instance
  end
end
