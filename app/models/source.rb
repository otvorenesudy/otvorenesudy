class Source < ActiveRecord::Base
  attr_accessible :module,
                  :name,
                  :data_uri,
                  :site_uri

  validates :module, presence: true
  validates :name,   presence: true
  
  validates :data_uri, presence: true
end
