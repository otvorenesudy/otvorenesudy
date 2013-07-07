module SearchHelper
  def form_params(params, &block)
    params.each_pair do |name, value|
      next if value.nil?

      if value.is_a? Array
        value.each { |v| yield "#{name}[]", v }
      else
        yield name, value
      end
    end
  end

  def search_sort_tag(params, values, options = {})
    values = values.map { |value| [t("search.sort.#{@model.to_s.underscore}.#{value.to_s.gsub(/\A_/, '')}"), value] }

    select_tag :sort, options_for_select(values, params[:sort]), class: :span2
  end

  def search_order_tag(params, order, options = {})
    options.merge! class: 'btn'

    param = params[:order] || :desc

    options[:class] << ' active' if order == param

    link_to(search_path(params.merge order: order), options) do
      icon_tag order == :asc ? :'chevron-up' : :'chevron-down'
    end
  end

  def link_to_search(type, body, options = {})
    url = url_for options[:params].merge!(controller: type, action: :search)

    link_to body, url, options.except(:params)
  end

  def link_to_courts_search(body, options = {})
    link_to_search(:courts, body, options)
  end

  def link_to_judges_search(body, options = {})
    link_to_search(:judges, body, options)
  end

  def link_to_hearings_search(body, options = {})
    link_to_search(:hearings, body, options)
  end

  def link_to_decrees_search(body, options = {})
    link_to_search(:decrees, body, options)
  end
end
