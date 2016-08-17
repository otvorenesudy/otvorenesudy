# TODO translate

module SelectionProceduresHelper
  def selection_procedure_title(procedure)
    title(*selection_procedure_identifiers(procedure) << 'Výberové konanie')
  end

  def selection_procedure_headline(procedure, options = {})
    join_and_truncate selection_procedure_identifiers(procedure), { separator: ' &ndash; ' }.merge(options)
  end

  private

  def selection_procedure_identifiers(procedure)
    [procedure.position, procedure.organization_name].reject(&:blank?)
  end
end
