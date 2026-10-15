# frozen_string_literal: true

# Judge selection procedures, hidden since October 2025: config/routes.rb has their routes commented out.
class SelectionProceduresController < SearchController
  include SelectionProcedureDocuments

  before_action :set_procedure, only: %i[show declaration report]

  def show
    @candidates = @procedure.candidates.order(:rank, :name).sort_by { |candidate| sort_key(candidate) }
    @commissioners = @procedure.commissioners.order(:name).sort_by { |commissioner| sort_key(commissioner) }
  end

  def declaration
    send_file_in @procedure.declaration_path, name: t('.file', id: @procedure.id)
  end

  def report
    send_file_in @procedure.report_path, name: t('.file', id: @procedure.id)
  end

  private

  def set_procedure
    @procedure = SelectionProcedure.find(params.expect(:id))
  end

  # By rank, when people have one, then by surname (the last word of the name) regardless of diacritics.
  def sort_key(person)
    surname = person.name[/\s((?:[^\s]|,\s)*)\z/, 1] || person.name
    surname = ActiveSupport::Inflector.transliterate(surname).downcase
    rank = person.rank if person.respond_to?(:rank)

    rank ? [rank, surname] : [surname]
  end
end
