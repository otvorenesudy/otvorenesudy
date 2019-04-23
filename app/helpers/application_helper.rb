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

  def container?
    %w(home map).exclude?(action_name) && !controller.is_a?(DeviseController)
  end

  def canonical_url
    "https://#{request.host}#{request.fullpath}"
  end

  def donation_url
    "https://transparency.darujme.sk/#{I18n.locale == :sk ? 238 : 761}?donation=40&periodicity=periodical"
  end

  def organization_url(path = nil)
    "https://github.com/#{Configuration.github.organization}/#{path}".sub(/\/\z/, '')
  end

  def repository_url(path = nil)
    organization_url "#{Configuration.github.repository}/#{path}".sub(/\/\z/, '')
  end
end
