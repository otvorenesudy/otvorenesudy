module Probe
  module Sanitizer
    private

    def extract_page_param(params)
      params[:page] && params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def extract_sort_param(params, sort_fields)
      if params[:sort] && sort_fields.include?(params[:sort].to_sym)
        params[:sort].to_sym
      else
        return sort_fields.first.to_sym if sort_fields.first

        :'_score'
      end
    end

    def extract_order_param(params)
      params[:order] == 'desc' ? :desc : :asc
    end
  end
end
