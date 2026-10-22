# frozen_string_literal: true

module ApplicationHelper
  DONATION_URL = 'https://transparency.darujme.sk/korupcia/?&donation=40&periodicity=periodical'

  def default_title
    t('layouts.application.title')
  end

  def resolve_title(value)
    return default_title if value.blank?
    return title(value) unless value.end_with?(default_title)

    value
  end

  def title(*values)
    safe_join(values + [default_title], ' &middot; '.html_safe)
  end

  def canonical_url
    "https://#{request.host}#{request.fullpath}"
  end

  def donation_url
    DONATION_URL
  end

  def organization_url(path = nil)
    "https://github.com/#{Rails.configuration.x.github.organization}/#{path}".delete_suffix('/')
  end

  def repository_url(path = nil)
    organization_url("#{Rails.configuration.x.github.repository}/#{path}".delete_suffix('/'))
  end
end
