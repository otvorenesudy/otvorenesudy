module Output
  attr_accessor :verbose
  alias :old_puts :puts
  alias :old_print :print
 
  def verbose=(value)
    @verbose = value
    @downloader.verbose = value unless @downloader.nil?
    @parser.verbose = value unless @parser.nil?
    @persistor.verbose = value unless @persistor.nil? 
  end

  def puts(*args)
    old_puts(args) if @verbose
  end

  def print(*args)
    old_print(args) if @verbose
  end
end
