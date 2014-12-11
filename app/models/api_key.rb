class ApiKey < ActiveRecord::Base
  before_create :generate_key

  def generate_key
    begin
      self.value = Generator.generate
    end while self.class.exists?(value: value)
  end

  class Generator
    def self.generate
      SecureRandom.hex
    end
  end
end
