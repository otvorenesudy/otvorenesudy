# encoding: utf-8

module ApplicationHelper
  def default_title
    t 'layouts.application.default_title'
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
    "http://#{request.host}#{request.fullpath}"
  end

  def url_to_organization(path = nil)
    File.join('https://github.com', Configuration.github.organization, path.to_s).sub(/\/\z/, '')
  end

  def url_to_repository(path = nil)
    url_to_organization "#{Configuration.github.repository}/#{path}"
  end
end
