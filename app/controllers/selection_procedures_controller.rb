class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    sorter = -> (c) do
      r = c.respond_to?(:rank) ? c.rank : nil
      n = c.name.match(/\s(([^\s]|\,\s)*)\z/)[1]
      [r, ActiveSupport::Inflector.transliterate(n).downcase]
    end

    @candidates    = @procedure.candidates.order(:rank, :name).sort_by(&sorter)
    @commissioners = @procedure.commissioners.order(:name).sort_by(&sorter)
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
