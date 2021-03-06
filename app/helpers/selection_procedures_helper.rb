module SelectionProceduresHelper
  def selection_procedure_title(procedure)
    title(*selection_procedure_identifiers(procedure) << t('selection_procedures.common.selection_procedure'))
  end

  def selection_procedure_headline(procedure, options = {})
    join_and_truncate selection_procedure_identifiers(procedure), options.reverse_merge(separator: ' &ndash; ')
  end

  private

  def selection_procedure_identifiers(procedure)
    [procedure.position, procedure.organization_name].reject(&:blank?)
  end
end
