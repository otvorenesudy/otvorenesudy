# encoding: utf-8

module DecreesHelper
  def decree_title(decree)
    # TODO for page title
  end

  # TODO rm?
  def decree_headline(decree)
    introduction = [decree.legislation_subarea, decree.form].reject(&:blank?).map(&:value)
    natures      = decree.natures.pluck(:value).join(', ')

    #["Súdne rozhodnutie", introduction, natures].join(' ').html_safe

    [introduction.join(' &ndash; '), natures].join(', ').html_safe
  end

  def decree_date(date)
    time_tag date, format: :long 
  end

  def link_to_decree(decree, options = {})
    link_to decree.file_number, decree_path(decree.id), options
  end

  def link_to_decree_with_params(title, decree, params, options = {})
    link_to title, decree_path_with_params(decree, params), options
  end

  def external_link_to_legislation(legislation, options = {})
    if legislation.year && legislation.number
      hash = "p#{legislation.paragraph}"
      hash << "-#{legislation.section}" if legislation.section
      hash << "-#{legislation.letter}"  if legislation.letter

      url = "http://www.zakonypreludi.sk/zz/#{legislation.year}-#{legislation.number}##{hash}"
    else
      url = "http://www.zakonypreludi.sk/main/search.aspx?text=#{legislation.value}"
    end

    external_link_to legislation.value, url, options
  end

  def decree_to_document_viewer(decree)
    result = Hash.new

    result[:name]   = "Rozhodnutie #{decree.file_number}"
    result[:number] = 1
    result[:pages]  = decree.pages.by_number.map do |page|
      { 
        number:  page.number,
        scanUrl: image_decree_page_path(decree, page.number),
        textUrl: text_decree_page_path(decree, page.number),
        comments: []
      }
    end

    result
  end

  def decree_path_with_params(decree, params, options = {})
    "#{decree_path(decree)}?#{params.map { |k, v| "#{k}=#{v}" if v }.join('&') }"
  end
end
