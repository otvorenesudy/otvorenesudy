class ApiKey < ActiveRecord::Base
  before_create :generate_key

  def generate_key
    begin
      self.key = Generator.generate
    end while self.class.exists?(key: key)
  end

  class Generator
    def self.generate
      SecureRandom.hex
    end
  end
end
