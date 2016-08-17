class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    @candidates    = @procedure.candidates.order(:rank, :name)
    @commissioners = @procedure.commissioners.order(:name)
  end

  def declaration
    @procedure = SelectionProcedure.find(params[:id])

    # TODO translate?
    send_file_in @procedure.declaration_path, name: "Vyhlásenie výberového konania č. #{@procedure.id}"
  end

  def report
    @procedure = SelectionProcedure.find(params[:id])

    # TODO translate?
    send_file_in @procedure.report_path, name: "Zápisnica výberového konania č. #{@procedure.id}"
  end

  protected

  include FileHelper
end
