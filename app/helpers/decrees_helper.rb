# encoding: utf-8

module DecreesHelper
  def decree_title(decree)
    options     = { separator: ' &middot; ', tooltip: false }
    identifiers = join_and_truncate decree_identifiers(decree), options.dup
    
    "#{identifiers}#{options[:separator]}Súdne rozhodnutie".html_safe
  end

  def decree_headline(decree, options = {})
    join_and_truncate decree_identifiers(decree), { separator: ' &ndash; ' }.merge(options)
  end
  
  def decree_natures(decree, options = {})
    join_and_truncate decree.natures.order(:value).pluck(:value), { separator: ', ' }.merge(options)
  end

  def decree_date(date, options = {})
    time_tag date, { format: :long }.merge(options)
  end

  def decree_as_attachments(decree)
    {
      name: "Súdne rozhodnutie #{decree.ecli}",
      number: 1,
      pages: decree.pages.by_number.map { |page|
        { 
          number:  page.number,
          scanUrl: image_decree_page_path(decree, page.number),
          textUrl: text_decree_page_path(decree, page.number),
          comments: []
        }
      }
    }
  end

  # TODO rm??
  def decree_path_with_params(decree, params)
    return decree_path decree if params.blank?
    
    "#{decree_path decree}?#{params.map { |k, v| "#{k}=#{v}" if v }.join '&'}"
  end

  def link_to_decree(decree, body, options = {})
    link_to body, decree_path_with_params(decree, options.delete(:params)), options
  end

  def link_to_decree_resource(decree, body, options = {})
    link_to body, "#{decree_path decree}/resource", { target: :_blank }.merge(options)
  end

  def link_to_decree_document(decree, body, options = {})
    link_to body, "#{decree_path decree}/document", { target: :_blank }.merge(options)
  end

  def external_link_to_legislation(legislation, options = {})
    if legislation.year && legislation.number
      url =  "http://www.zakonypreludi.sk/zz/#{legislation.year}-#{legislation.number}#"
      url << 'p' << legislation.paragraph if legislation.paragraph
      url << '-' << legislation.section   if legislation.section
      url << '-' << legislation.letter    if legislation.letter
    else
      url = 'http://www.zakonypreludi.sk/main/search.aspx?text=' + legislation.value
    end

    external_link_to legislation.value, url, options
  end
    
  private
  
  def decree_identifiers(decree)
    [decree.form, decree.legislation_subarea].reject(&:blank?).map(&:value)
  end
end
