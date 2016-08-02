class SelectionProcedureCandidatesController < SearchController
  def application
    @candidate = SelectionProcedureCandidate.find(params[:id])

    # TODO translate?
    send_file_in @candidate.application_path, name: "Žiadosť kandiáta výberového konania #{identify @candidate}"
  end

  def curriculum
    @candidate = SelectionProcedureCandidate.find(params[:id])

    # TODO translate?
    send_file_in @candidate.curriculum_path, name: "Životopis kandiáta výberového konania #{identify @candidate}"
  end

  def declaration
    @candidate = SelectionProcedureCandidate.find(params[:id])

    # TODO translate?
    send_file_in @candidate.declaration_path, name: "Vyhlásenie kandiáta výberového konania #{identify @candidate}"
  end

  def motivation_letter
    @candidate = SelectionProcedureCandidate.find(params[:id])

    # TODO translate?
    send_file_in @candidate.motivation_letter_path, name: "Motivačný list kandiáta výberového konania #{identify @candidate}"
  end

  protected

  include FileHelper

  def identify(candidate)
    "č. #{candidate.procedure.id}-#{candidate.id} #{candidate.name}"
  end
end
