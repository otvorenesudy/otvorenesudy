module JusticeGovSk
  class Persistor
    include Core::Persistor

    def persist(instance)
      super

      # TODO refactor this fix
      [Court, Judge, Hearing, Decree, Proceeding].each do |model|
        if instance.is_a? model
          model.find(instance.id).save!
          break
        end
      end

      # TODO rm
      #super
      #
      #if instance.respond_to? :update_index
      #  print "Updating index #{identify instance} ... "
      #
      #  instance.update_index
      #
      #  puts "done (#{identify instance})"
      #end

      instance
    end
  end
end
