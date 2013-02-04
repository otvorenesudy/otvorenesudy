module ElasticSearch
  module Autocomplete

    def self.extended(base)
      base.settings analysis: { 
        filter: {
          autocomplete_ngram: {
            :type      => 'NGram',
            :min_gram  => 1,
            :max_gram  => 10,
          }
        },
        analyzer: {
          autocomplete_analyzer: {
            :type      => 'custom',
            :tokenizer => 'standard',
            :filter    => %w(lowercase asciifolding autocomplete_ngram)
          }
        }
      }
    end

    def suggest(field, term, options = {})
      options[:count] ||= 5

      result = search per_page: options[:count] do
        query do
          string "#{field.to_s}:#{term}"
        end
      end
      
      result.results.map { |el| el[field] }
    end

    def autocomplete(params)
      mapping do
        if params.respond_to?(:each)
          params.each do |column|
            indexes column, analyzer: 'autocomplete_analyzer'              
          end
        else
          indexes params, analyzer: 'autocomplete_analyzer'
        end     
      end
    end
  end
end
