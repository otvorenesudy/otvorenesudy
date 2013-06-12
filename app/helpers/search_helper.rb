module SearchHelper
  def link_to_search(type, body, options)
    params = options[:params]

    url = url_for params.merge!(controller: type, action: :search)

    link_to body, url, options.except(:params)
  end

  def link_to_hearings_search(body, options)
    link_to_search(:hearings, body, options)
  end

  def link_to_decrees_search(body, options)
    link_to_search(:decrees, body, options)
  end

  def link_to_judges_search(body, options)
    link_to_search(:judges, body, options)
  end

  def link_to_courts_search(body, options)
    link_to_search(:courts, body, options)
  end

  def search_sort_select_tag(values, params, options = {})
    values = values.map { |value| [sort_option_title(value), value] }

    select_tag :sort, options_for_select(values, params[:sort])
  end

  def order_tag(params, order, options)
    options.merge! class: 'btn'

    options[:class] << ' active' if order == params[:order]

    link_to search_path(params.merge(order: order)), options do
      icon_tag order == :asc ? :'chevron-up' : :'chevron-down'
    end
  end

  private

  def sort_option_title(value)
    t "search.sort.#{value.to_s.gsub(/\A_/, '')}"
  end
end
