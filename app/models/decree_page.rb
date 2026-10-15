# frozen_string_literal: true

class DecreePage < ApplicationRecord
  include Probe

  belongs_to :decree, optional: true

  scope :by_number, -> { order(:number) }

  validates :number, presence: true
  validates :text, presence: true

  mapping do
    map :decree_id
    map :number

    analyze :text, index: :no
  end

  # The decree's pages matching the text, with their highlighted fragments: [response, { number => [fragment] }].
  def self.search_pages(decree_id, text)
    field = Probe::Fields.analyzed(:text)
    query = Probe::Sanitizer.query_string(text)
    body = {
      query: {
        bool: {
          filter: [{ term: { decree_id: decree_id.to_s } }],
          must: [{ query_string: { query:, default_field: field, default_operator: 'OR', analyze_wildcard: true } }]
        }
      },
      highlight: { fields: { field => {} } },
      _source: %w[number]
    }

    response = client.search(index: index_name, body:)
    highlights = response['hits']['hits'].to_h do |hit|
      [hit.dig('_source', 'number').to_i, hit.dig('highlight', field).to_a]
    end

    [response, highlights]
  end
end
