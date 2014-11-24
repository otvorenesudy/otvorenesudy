class SelectionProcedureCandidate < ActiveRecord::Base
  include Resource::Storage

  attr_accessible :application_url,
                  :curriculum_url,
                  :declaration_url,
                  :motivation_letter_url,
                  :name,
                  :name_unprocessed,
                  :accomplished_expectations,
                  :oral_score,
                  :oral_result,
                  :written_score,
                  :written_result,
                  :score,
                  :rank

  belongs_to :procedure, class_name: :SelectionProcedure, foreign_key: :selection_procedure_id
  belongs_to :judge

  storage(:application,       JusticeGovSk::Storage::SelectionProcedureCandidateDocument) { |candidate| "#{candidate.uri.match(/Ic=(\d+)/)[1]}_application.pdf" }
  storage(:curriculum,        JusticeGovSk::Storage::SelectionProcedureCandidateDocument) { |candidate| "#{candidate.uri.match(/Ic=(\d+)/)[1]}_curriculum.pdf" }
  storage(:declaration,       JusticeGovSk::Storage::SelectionProcedureCandidateDocument) { |candidate| "#{candidate.uri.match(/Ic=(\d+)/)[1]}_declaration.pdf" }
  storage(:motivation_letter, JusticeGovSk::Storage::SelectionProcedureCandidateDocument) { |candidate| "#{candidate.uri.match(/Ic=(\d+)/)[1]}_motivation_letter.pdf" }
end
