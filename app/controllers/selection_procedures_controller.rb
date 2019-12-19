class SelectionProceduresController < SearchController
  def show
    @procedure = SelectionProcedure.find(params[:id])

    sorter = lambda do |c|
      rank = c.respond_to?(:rank) ? c.rank : nil
      name = c.name.match(/\s(([^\s]|\,\s)*)\z/).try(:[], 1) || c.name
      transliterated = ActiveSupport::Inflector.transliterate(name).downcase

      next [transliterated] unless rank

      [rank, ActiveSupport::Inflector.transliterate(name).downcase]
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
