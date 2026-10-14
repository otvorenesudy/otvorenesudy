# frozen_string_literal: true

class DecreeNaturalization < ApplicationRecord
  belongs_to :decree, optional: true

  belongs_to :nature, class_name: 'DecreeNature', foreign_key: :decree_nature_id, inverse_of: false, optional: true
end
