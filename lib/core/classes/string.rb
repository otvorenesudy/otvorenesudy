class String
  def upcase_first
    self.sub(/^\D{0,1}/) { |c| c.upcase }
  end
  
  def upcase_first!
    self.sub!(/^\D{0,1}/) { |c| c.upcase }
  end
end
