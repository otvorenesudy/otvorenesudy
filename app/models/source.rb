class Source < ActiveRecord::Base
  attr_accessible :module,
                  :name,
                  :uri

  validates :module, presence: true
  validates :name,   presence: true
  validates :uri,    presence: true
  
  def self.of(base)
    @modules ||= {}
    
    base = base.to_s
    
    @modules[base.to_sym] ||= Source.where('module' => base).first
  end
end
