# encoding: utf-8

module JusticeGovSk
  module Helper
    module ContentValidator
      include Core::Output
      
      def valid_content?(path, format, options = {})
        print "Validating #{format.to_s.split(/\_/).map { |v| v =~ /html|pdf/i ? v.upcase : v }.join ' '} #{path} ... "
        
        result = send("#{format}?", path)
        
        if result
          puts "done"
        else
          puts "failed"
          
          unless options[:keep_invalid]
            print "Removing #{path} ... "
            
            FileUtils.rm path
            
            puts "done"
          end
        end
        
        result
      end
      
      def decree_pdf?(path)
        (File.read(path, 32) =~ /\%PDF-\d+\.\d+.*/) == 0
      end

      def decree_html?(path)
        (File.read(path) =~ /\<h1\>Detail\ssúdneho\srozhodnutia\<\/h1\>/i) != nil
      end
            
      def hearing_html?(path)
        (File.read(path) =~ /\<h1\>Detail\spojednávania\<\/h1\>/i) != nil
      end
    end      
  end
end
