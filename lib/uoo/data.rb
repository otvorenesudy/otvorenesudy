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

      approved_chains = entries.each_with_object(Set.new) do |entry, set|
        set << entry['chain_root_decree_url'] if entry['approves_or_confirms_chain_root_decree'] == true
      end

      entries = entries.map do |entry|
        entry.merge(
          'root' => entry['parent_decree_url'].nil?,
          'approved' => approved_chains.include?(entry['chain_root_decree_url'])
        )
      end

      entries.sort_by { |d| [d['parsed_date'] ? 0 : 1, d['parsed_date'] ? -d['parsed_date'].jd : 0] }
    end

    def self.build_stats
      entries = decrees

      by_party = entries.each_with_object({}) do |entry, hash|
        Array.wrap(entry['parties']).each do |party|
          name = party['name'].to_s.strip
          next if name.blank?

          row = hash[name] ||= { name: name, count: 0, fine: 0, currency: nil }
          row[:count] += 1
          if entry['root'] && entry['approved']
            row[:fine] += party['fine_amount'].to_i
            row[:currency] ||= party['fine_currency']
          end
        end
      end

      rows = by_party.values.sort_by { |row| [-row[:fine], -row[:count], row[:name]] }

      {
        total_count: entries.size,
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
