class Source < ActiveRecord::Base
  attr_accessible :module,
                  :name,
                  :base_uri,
                  :data_uri

  validates :module, presence: true
  validates :name,   presence: true
  
  validates :base_uri, presence: true
  validates :data_uri, presence: true
end
