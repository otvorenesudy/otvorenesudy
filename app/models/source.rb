class Source < ActiveRecord::Base
  attr_accessible :module,
                  :name,
                  :uri

  validates :module, presence: true
  validates :name,   presence: true
  validates :uri,    presence: true
end
