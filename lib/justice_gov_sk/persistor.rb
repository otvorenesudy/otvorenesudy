module JusticeGovSk
  class Persistor
    include Core::Persistor

    # TODO rm
    #def persist(instance)
    #  super
    #
    #  if instance.respond_to? :update_index
    #    print "Updating index #{identify instance} ... "
    #
    #    instance.update_index
    #
    #    puts "done (#{identify instance})"
    #  end
    #
    #  instance
    #end
  end
end
