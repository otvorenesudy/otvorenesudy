class SelectionProcedure < ActiveRecord::Base
  include Probe
  include Resource::URI
  include Resource::Storage

  attr_accessible :declaration_url,
                  :report_url,
                  :organization_name,
                  :organization_name_unprocessed,
                  :organization_description,
                  :date,
                  :description,
                  :place,
                  :position,
                  :state,
                  :workplace,
                  :closed_at

  belongs_to :court

  has_many :candidates,    class_name: :SelectionProcedureCandidate
  has_many :commissioners, class_name: :SelectionProcedureCommissioner

  max_paginates_per 100
  paginates_per     20

  mapping do
    map :id

    analyze :organization_name
    analyze :date,                type: :date
    analyze :closed_at,           type: :date
    analyze :place
    analyze :position
    analyze :state
    analyze :workplace
    analyze :candidates,                          as: lambda { |p| p.candidates.pluck(:name) }
    analyze :candidates_count,    type: :integer, as: lambda { |p| p.candidates.count }
    analyze :commissioners,                       as: lambda { |p| p.commissioners.pluck(:name) }
    analyze :commissioners_count, type: :integer, as: lambda { |p| p.commissioners.count }

    sort_by :date, :closed_at, :created_at
  end

  facets do
    facet :q,                 type: :fulltext, field: :all, visible: false
    facet :position,          type: :terms
    facet :state,             type: :terms, size: SelectionProcedure.pluck(:state).uniq.count
    facet :candidates,        type: :terms
    facet :organization_name, type: :terms
    facet :commissioners,     type: :terms
    facet :date,              type: :date, interval: :month
    facet :closed_at,         type: :date, interval: :month
    #facet :place,             type: :terms
    #facet :workplace,         type: :terms
    facet :candidates_count,  type: :range, ranges: [1..1, 2..2, 3..5, 5..10, 10..20, 20..50]
  end

  storage(:declaration, JusticeGovSk::Storage::SelectionProcedureDocument) { |procedure| "#{procedure.uri.match(/Ic=(\d+)/)[1]}_declaration.pdf" }
  storage(:report,      JusticeGovSk::Storage::SelectionProcedureDocument) { |procedure| "#{procedure.uri.match(/Ic=(\d+)/)[1]}_report.pdf" }
end
