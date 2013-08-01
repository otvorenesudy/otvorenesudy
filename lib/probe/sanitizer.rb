module Probe
  module Sanitizer
    private

    def extract_page_param(params)
      params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def extract_sort_param(params, sort_fields)
      if sort_fields.include?(params[:sort].to_sym)
        params[:sort].to_sym
      else
        return sort_fields.first.to_sym if sort_fields.first

        :'_score'
      end
    end

    def extract_order_param(params)
      params[:order] == 'asc' ? :asc : :desc
    end

    def sanitize_query_string(value)
      value = value.gsub(/(\+|\-|&&|\||\||\(|\)|\{|\}|\[|\]|\^|~|\!|\\|\/)/) { |m| "\\#{m}" }

      value[value.rindex('"')] = "\\\"" unless value.count('"') % 2 == 0

      value
    end

    def sanitize_suggest_string(value)
      value.gsub(/[\"\'\{\}\[\]\(\)]/, '')
    end
  end
end
