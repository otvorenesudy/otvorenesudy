# frozen_string_literal: true

require 'json'

module Uoo
  # The decisions of the Whistleblower Protection Office (data/uoo-decrees.json): first decisions, each with the appeals
  # that decided on it, newest first, and the decisions and fines per party.
  module Data
    SOURCE = Rails.root.join('data/uoo-decrees.json').freeze

    def self.all
      decrees
    end

    # The office's page of decisions, when the data names a web address for it.
    def self.source_url
      uri = URI.parse(raw['source_url'].to_s.strip)

      uri.to_s if uri.is_a?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      nil
    end

    def self.decrees
      @decrees ||= build_decrees
    end

    def self.stats
      @stats ||= build_stats
    end

    def self.reload!
      @raw = @decrees = @stats = nil
    end

    class << self
      private

      def build_decrees
        entries = Array.wrap(raw['decrees']).map { |entry| entry.merge('parsed_date' => parse_date(entry['date'])) }
        roots, children = entries.partition { |entry| entry['parent_decree_url'].nil? }
        approved = approved_chains(entries)

        roots.map { |root| with_children(root, children, approved) }.sort_by { |entry| date_order(entry) }
      end

      # A first decision with its appeals; approved when no appeal changed it.
      def with_children(root, children, approved_chains)
        chain = root['chain_root_decree_url']
        appeals = children.select { |child| child['chain_root_decree_url'] == chain }
        appeals = appeals.sort_by { |entry| date_order(entry) }

        root.merge('approved' => appeals.empty? || approved_chains.include?(chain), 'children' => appeals)
      end

      def approved_chains(entries)
        entries.select { |entry| entry['approves_or_confirms_chain_root_decree'] == true }
               .to_set { |entry| entry['chain_root_decree_url'] }
      end

      # Newest first, undated last.
      def date_order(entry)
        date = entry['parsed_date']

        date ? [0, -date.jd] : [1, 0]
      end

      def build_stats
        rows = party_rows.sort_by { |row| [-row[:fine], -row[:count], row[:name]] }

        {
          total_count: decrees.size,
          total_fine: rows.sum { |row| row[:fine] },
          currency: rows.pluck(:currency).compact.first || 'EUR',
          by_party: rows
        }
      end

      # Each party of the first decisions with its decisions and fines.
      def party_rows
        decrees.flat_map { |entry| Array.wrap(entry['parties']) }.each_with_object({}) do |party, rows|
          name = party['name'].to_s.strip
          next if name.blank?

          row = rows[name] ||= { name:, count: 0, fine: 0, currency: nil }
          row[:count] += 1
          row[:fine] += party['fine_amount'].to_i
          row[:currency] ||= party['fine_currency']
        end.values
      end

      def parse_date(value)
        return if value.blank?

        Date.strptime(value.to_s.gsub(/\s+/, ''), '%d.%m.%Y')
      rescue ArgumentError
        nil
      end

      def raw
        @raw ||= JSON.parse(File.read(SOURCE))
      end
    end
  end
end
