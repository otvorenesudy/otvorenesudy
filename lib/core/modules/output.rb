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
<<<<<<< HEAD
    default_puts(args) if @verbose
  end

  def print(*args)
    default_print(args.join) if @verbose
=======
    old_puts(*args) if @verbose
  end

  def print(*args)
    old_print(*args) if @verbose
>>>>>>> a49694debd833885c06f40771c5b4095bc928670
  end
end
