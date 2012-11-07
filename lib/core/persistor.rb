class Persistor
  include Identify
  include Output
  
  def persist(instance)
    print "Persisting #{identify instance} ... "

    instance.save!    

    puts "done (#{identify instance})"
    
    instance
  end
end
