require 'active_support/multibyte'

class String
  alias :utf8 :mb_chars

  def ascii
    return self if self.ascii_only?

    self.utf8.normalize(:kd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
  end

  # TODO switch to Ruby 2.4.0 where *case methods handle Unicode instead of only ASCII by default

  def downcase_first
    self.dup.downcase_first!
  end

  def downcase_first!
    self.sub!(/\A./) { |c| c.mb_chars.downcase }
  end

  def upcase_first
    self.dup.upcase_first!
  end

  def upcase_first!
    self.sub!(/\A./) { |c| c.mb_chars.upcase }
  end
end
