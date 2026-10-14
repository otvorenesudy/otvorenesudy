# frozen_string_literal: true

module Probe
  class Facets
    # The most frequent values of a field (court, judge, form...), plus "missing" for records without one.
    class TermsFacet < Facet
      class Result < Facet::Result
        def missing?
          value == MISSING
        end

        alias missing missing?
      end

      # Each base letter and the Latin letters that fold to it, in both cases: "c" matches c, C, č, Č, ć, Ć...
      LETTERS = ((0x41..0x5a).to_a + (0x61..0x7a).to_a + (0xc0..0x17f).to_a)
                .map { |code| code.chr(Encoding::UTF_8) }
                .group_by { |letter| letter.unicode_normalize(:nfkd)[0].downcase }
                .select { |base, _| base.match?(/\A[a-z]\z/) }
                .transform_values { |letters| "[#{letters.join}]" }
                .freeze

      # Characters with a meaning in Lucene's regular expressions.
      RESERVED = /[.?+*|{}\[\]()"\\#@&<>~]/

      def filter
        { bool: { should: terms.map { |value| term_filter(value) }, minimum_should_match: 1 } }
      end

      def aggregation
        selected = terms - [MISSING]
        aggregation = {
          values: { terms: { field: keyword_field, size: } },
          missing: { missing: { field: keyword_field } }
        }

        if selected.any?
          aggregation[:selected] =
            { terms: { field: keyword_field, include: selected, size: selected.size } }
        end
        aggregation
      end

      # Records whose field has a word starting with the term, and the values that contain it, regardless of case and
      # diacritics.
      def suggest_query(term)
        query = "#{Probe::Sanitizer.query_string(Probe::Sanitizer.suggest_string(term))}*"

        { query_string: { query:, fields: [analyzed_field], default_operator: 'AND', analyze_wildcard: true } }
      end

      def suggest_aggregation(term)
        aggregation = { field: keyword_field, size: }
        aggregation[:include] = suggest_pattern(term) if term.present?

        { terms: aggregation }
      end

      private

      def term_filter(value)
        return { bool: { must_not: { exists: { field: keyword_field } } } } if value == MISSING

        { term: { keyword_field => value } }
      end

      def suggest_pattern(term)
        folded = term.to_s.first(100).unicode_normalize(:nfkd).gsub(/\p{Mn}/, '').downcase
        pattern = folded.chars.map { |char| LETTERS[char] || char.gsub(RESERVED) { |c| "\\#{c}" } }.join

        ".*#{pattern}.*"
      end

      def build_results(response)
        buckets = response.dig('values', 'buckets').to_a
        results = buckets.map { |bucket| result(bucket_value(bucket), bucket['doc_count']) }
        missing = response.dig('missing', 'doc_count').to_i

        missing.positive? ? results + [result(MISSING, missing)] : results
      end

      def build_selected(response)
        response.dig('selected', 'buckets').to_a.map { |bucket| result(bucket_value(bucket), bucket['doc_count']) }
      end

      def bucket_value(bucket)
        bucket['key_as_string'] || bucket['key'].to_s
      end
    end
  end
end
