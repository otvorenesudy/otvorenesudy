module Output
  attr_accessor :verbose
  
  alias :default_print :print
  alias :default_puts  :puts
  
  def verbose=(value)
    @verbose = value.nil? ? true : value
  end
  
  def verbose
    @verbose.nil? ? true : @verbose
  end

  def puts(*args)
    default_puts(args) if @verbose
  end

  def print(*args)
    default_print(args.join) if @verbose
  end
end
