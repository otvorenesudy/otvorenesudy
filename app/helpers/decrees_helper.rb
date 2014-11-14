# encoding: utf-8

module DecreesHelper
  def decree_title(decree)
    title(*decree_identifiers(decree) << 'Súdne rozhodnutie')
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
          number: page.number,
          scanUrl: image_decree_page_path(decree, page.number),
          textUrl: text_decree_page_path(decree, page.number),
          comments: []
        }
      }
    }
  end

  def link_to_decree(decree, body, options = {})
    link_to body, decree_path(decree, options[:params]), options
  end

  def link_to_decree_resource(decree, body, options = {})
    external_link_to body, "#{decree_path decree}/resource", options
  end

  def link_to_decree_document(decree, body, options = {})
    external_link_to body, "#{decree_path decree}/document", options
  end

  def external_link_to_legislation(legislation, options = {})
    external_link_to legislation.value(options.delete(:format)), legislation.external_url, { icon: true }.merge(options)
  end

  private

  def decree_identifiers(decree)
    [decree.form, decree.legislation_subarea].reject(&:blank?).map(&:value)
  end
end
