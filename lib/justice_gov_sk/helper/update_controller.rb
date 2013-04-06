module JusticeGovSk
  module Helper
    module UpdateController
      include Core::Identify
      include Core::Output
      
      module Resource
        include JusticeGovSk::Helper::UpdateController
        
        def exists?(type, uri)
          type.exists?(uri: uri)
        end

        def changeable?(type, uri)
          !exists?(type, uri) || updateable?(type)
        end
      end
      
      module Instance
        include JusticeGovSk::Helper::UpdateController
        
        def exists?(instance)
          !instance.id.nil?
        end
        
        def updateable?(instance)
          super instance.class
        end

        def changeable?(instance)
          !exists?(instance) || updateable?(instance)
        end
      end
      
      def updateable?(type)
        @updateable ||= JusticeGovSk::Configuration.resource.updateable.map(&:constantize)
        
        @updateable.select { |t| t <= type }.any?
      end
      
      def crawlable?(*args)
        print "Performing processor checks using "
        print "#{args.map { |arg| arg.respond_to?(:id) ? identify(arg) : arg }.join ', '} ... "
        
        result = changeable?(*args)
        
        puts "#{result ? 'done' : 'failed'}#{exists?(*args) ? ' (already crawled)' : ''}"
        
        result
      end
    end
  end
end
