class DecreeNaturalization < ActiveRecord::Base
  belongs_to :decree

  belongs_to :nature, class_name: DecreeNature, foreign_key: :decree_nature_id
end
