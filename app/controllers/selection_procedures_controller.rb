class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    @candidates    = @procedure.candidates.order(:rank, :name)
    @commissioners = @procedure.commissioners.order(:name)
  end

  def declaration
    @procedure = SelectionProcedure.find(params[:id])

    send_file_in @procedure.declaration_path, name: t('selection_procedures.declaration.file', id: @procedure.id)
  end

  def report
    @procedure = SelectionProcedure.find(params[:id])

    send_file_in @procedure.report_path, name: t('selection_procedures.report.file', id: @procedure.id)
  end

  protected

  include FileHelper
end
