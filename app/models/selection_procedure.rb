class SelectionProcedure < ActiveRecord::Base
  include Resource::URI

  attr_accessible :organization_name,
                  :organization_name_unprocessed,
                  :organization_description,
                  :date,
                  :description,
                  :place,
                  :position,
                  :state,
                  :workplace,
                  :closed_at

  belongs_to :court

  has_many :candidate,     class_name: :SelectionProcedureCandidate
  has_many :commissioners, class_name: :SelectionProcedureCommissioner
end
