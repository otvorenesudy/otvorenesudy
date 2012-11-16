require 'active_support/multibyte'

class String
  alias :utf8 :mb_chars
  
  def ascii
    return self if self.ascii_only?
    
    self.utf8.normalize(:kd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
  end
  
  def upcase_first
    self.sub(/^\D{0,1}/) { |c| c.upcase }
  end
  
  def upcase_first!
    self.sub!(/^\D{0,1}/) { |c| c.upcase }
  end
  
  def underscore
    self.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
  end
  
  def underscore!
    self.gsub!(/::/, '/')
        .gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        .tr!('-', '_')
        .downcase!
  end
end
