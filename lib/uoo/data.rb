require 'json'
require 'date'
require 'uri'

module Uoo
  module Data
    SOURCE = Rails.root.join('data', 'uoo-decrees.json').freeze

    def self.all
      decrees
    end

    def self.source_url
      value = raw['source_url'].to_s.strip
      return nil if value.blank?

      uri = URI.parse(value)
      return nil unless uri.is_a?(URI::HTTP) && uri.host.present?

      uri.to_s
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
      @raw = nil
      @decrees = nil
      @stats = nil
    end

    def self.build_decrees
      entries = Array.wrap(raw['decrees']).map { |entry| entry.merge('parsed_date' => parse_date(entry['date'])) }

      approved_chains =
        entries.each_with_object(Set.new) do |entry, set|
          set << entry['chain_root_decree_url'] if entry['approves_or_confirms_chain_root_decree'] == true
        end

      roots = entries.select { |e| e['parent_decree_url'].nil? }
      children = entries.select { |e| e['parent_decree_url'].present? }

      date_sort = ->(d) { [d['parsed_date'] ? 0 : 1, d['parsed_date'] ? -d['parsed_date'].jd : 0] }

      roots =
        roots.map do |root|
          chain_root = root['chain_root_decree_url']
          standalone = children.none? { |c| c['chain_root_decree_url'] == chain_root }
          approved = standalone || approved_chains.include?(chain_root)

          root_children = children.select { |c| c['chain_root_decree_url'] == chain_root }.sort_by(&date_sort)

          root.merge('approved' => approved, 'children' => root_children)
        end

      roots.sort_by(&date_sort)
    end

    def self.build_stats
      roots = decrees

      by_party =
        roots.each_with_object({}) do |entry, hash|
          Array
            .wrap(entry['parties'])
            .each do |party|
              name = party['name'].to_s.strip
              next if name.blank?

              row = hash[name] ||= { name: name, count: 0, fine: 0, currency: nil }
              row[:count] += 1
              row[:fine] += party['fine_amount'].to_i
              row[:currency] ||= party['fine_currency']
            end
        end

      rows = by_party.values.sort_by { |row| [-row[:fine], -row[:count], row[:name]] }

      {
        total_count: roots.size,
        total_fine: rows.sum { |row| row[:fine] },
        currency: rows.map { |row| row[:currency] }.compact.first || 'EUR',
        by_party: rows
      }
    end

    def self.parse_date(value)
      return nil if value.blank?

      normalized = value.to_s.gsub(/\s+/, '')
      Date.strptime(normalized, '%d.%m.%Y')
    rescue ArgumentError
      nil
    end

    def self.raw
      @raw ||= JSON.parse(File.read(SOURCE))
    end
  end
end
