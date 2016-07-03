module ApplicationHelper
  def default_title
    t 'layouts.application.title'
  end

  def resolve_title(value)
    return default_title if value.blank?
    return title(value) unless value.end_with? default_title
    value
  end

  def title(*values)
    (values << default_title).map { |value| html_escape value }.join(' &middot; ').html_safe
  end

  def canonical_url
    "https://#{request.host}#{request.fullpath}"
  end

  def donation_url
    "https://transparency.darujme.sk/#{I18n.locale == :sk ? 238 : 761}"
  end

  def url_to_organization(path = nil)
    File.join('https://github.com', Configuration.github.organization, path.to_s).sub(/\/\z/, '')
  end

  def url_to_repository(path = nil)
    url_to_organization "#{Configuration.github.repository}/#{path}"
  end
end
