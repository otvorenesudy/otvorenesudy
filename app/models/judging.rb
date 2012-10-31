class Judging < ActiveRecord::Base
  belongs_to :judge
  belongs_to :hearing
end
