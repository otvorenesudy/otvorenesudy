# frozen_string_literal: true

# Documents of candidates in judge selection procedures, hidden with them (see SelectionProceduresController).
class SelectionProcedureCandidatesController < ApplicationController
  include SelectionProcedureDocuments

  def declaration
    candidate = SelectionProcedureCandidate.find(params.expect(:id))
    name = t('selection_procedures.candidates.declaration.file', id: "#{candidate.procedure.id}-#{candidate.id}",
                                                                 name: candidate.name)

    send_file_in candidate.declaration_path, name:
  end
end
