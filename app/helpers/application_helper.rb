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

  def support_us_url
    "https://transparency.darujme.sk/#{I18n.locale == :sk ? 238 : 761}?donation=40&periodicity=periodical"
  end

  def github_organization_url
    "https://github.com/#{Configuration.github.organization}"
  end

  def github_repository_url(path = nil)
    [github_organization_url, Configuration.github.repository, path].compact.join('/')
  end
end
