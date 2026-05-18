module Resource::URI
  extend ActiveSupport::Concern

  included do

    belongs_to :source 
  end
end
