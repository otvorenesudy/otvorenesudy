# frozen_string_literal: true

# Judge selection procedures, crawled from justice.gov.sk until 2019. Hidden from the site since October 2025 (their
# routes are commented out); kept until the pages come back.
class SelectionProcedure < ApplicationRecord
  include Probe
  include Resource::URI
  include Resource::Storage

  belongs_to :court, optional: true

  has_many :candidates, class_name: 'SelectionProcedureCandidate', dependent: nil, inverse_of: :procedure
  has_many :commissioners, class_name: 'SelectionProcedureCommissioner', dependent: nil

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :organization_name
    analyze :date, type: :date
    analyze :closed_at, type: :date
    analyze :place
    analyze :position
    analyze :state
    analyze :workplace
    analyze :candidates, as: ->(procedure) { procedure.candidates.pluck(:name) }
    analyze :candidates_count, type: :integer, as: ->(procedure) { procedure.candidates.count }
    analyze :commissioners, as: ->(procedure) { procedure.commissioners.pluck(:name) }
    analyze :commissioners_count, type: :integer, as: ->(procedure) { procedure.commissioners.count }

    sort_by :date, :closed_at, :created_at
  end

  facets do
    facet :q, type: :fulltext, field: :all
    facet :position, type: :terms
    facet :state, type: :terms, size: -> { SelectionProcedure.distinct.count(:state) }
    facet :candidates, type: :terms
    facet :organization_name, type: :terms
    facet :commissioners, type: :terms
    facet :date, type: :date, interval: :month
    facet :closed_at, type: :date, interval: :month
    facet :candidates_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10, 10..20, 20..50]
  end

  storage(:declaration, 'documents/selection_procedures') { |procedure| "#{procedure.ic}_declaration.pdf" }
  storage(:report, 'documents/selection_procedures') { |procedure| "#{procedure.ic}_report.pdf" }

  # The procedure's id on justice.gov.sk.
  def ic
    uri[/Ic=(\d+)/, 1]
  end
end
