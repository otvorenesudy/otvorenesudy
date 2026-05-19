require 'json'
require 'date'

module Uoo
  module Data
    SOURCE = Rails.root.join('data', 'uoo-decrees.json').freeze

    def self.all
      decrees
    end

    def self.source_url
      raw['source_url']
    end

    def self.decrees
      @decrees ||= build_decrees
    end

    def self.reload!
      @raw = nil
      @decrees = nil
    end

    def self.build_decrees
      titles = titles_by_url

      decrees = Array.wrap(raw['data']).map do |entry|
        entry.merge(
          'title' => titles[entry['url']],
          'parsed_date' => parse_date(entry['date'])
        )
      end

      decrees.sort_by { |d| [d['parsed_date'] ? 0 : 1, d['parsed_date'] ? -d['parsed_date'].jd : 0] }
    end

    def self.titles_by_url
      Array.wrap(raw['pdfs']).each_with_object({}) do |pdf, hash|
        hash[pdf['url']] = pdf['title']
      end
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
