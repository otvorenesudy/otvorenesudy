module Core
  module Output
    attr_accessor :colored,
                  :verbose

    alias :default_print :print
    alias :default_puts  :puts

    def colored=(value)
      @colored = (value == true)
    end

    def colored
      @colored.nil? ? Core::Configuration.output.colors : @colored
    end

    def verbose=(value)
      @verbose = (value == true)
    end

    def verbose
      @verbose.nil? ? Core::Configuration.output.verbose : @verbose
    end

    def puts(*args)
      *args = colorize(args) if colored
      default_puts(*args)    if verbose
    end

    def print(*args)
      *args = colorize(args) if colored
      default_print(*args)   if verbose
    end

    private

    def colorize(args)
      args.map do |arg|
        arg = arg.to_s

        arg.gsub!(/^(settings|processing\s+list).*$/i) do |s|
          i = (s.index(/ngs/i) || s.index(/ing/i)) + 3
          s[0..i - 1].yellow.bold + s[i..-1].bold
        end

        arg.gsub!(/^(running|request)/i) { |s| s.bold       }
        arg.gsub!(/^finished/i)          { |s| s.green.bold }
        arg.gsub!(/^aborted/i)           { |s| s.red.bold   }
       #arg.gsub!(/^\w+ing/)             { |s| s.underline  }
        arg.gsub!(/\w+(\:\:\w+)+/)       { |s| s.blue.bold  }
        arg.gsub!(/[a-z]+\:(\?|\d+)/i)   { |s| s.bold       }
        arg.gsub!(/done/i)               { |s| s.green.bold }
        arg.gsub!(/failed/i)             { |s| s.red.bold   }

        arg
      end
    end
  end
end
