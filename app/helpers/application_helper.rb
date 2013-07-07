# encoding: utf-8

module ApplicationHelper
  def default_title
    'Otvorené súdy'
  end

  def title(*values)
    (values << default_title).map { |value| html_escape value }.join(' &middot; ').html_safe
  end

  def obtain(value)
    return default_title if value.blank?
    return title(value) unless value.end_with? default_title

    value
  end

  def canonical_url
    "http://#{request.host}#{request.fullpath}"
  end

  def flash
    return @flash if @flash

    @flash = super

    if defined?(resource) && (messages = resource.errors.full_messages.uniq).any? 
      @flash.now[:error] = Array.wrap @flash.now[:error]
      
      messages.each do |message|
        @flash.now[:error] << (message.end_with?('.') ? message : message + '.')
      end
    end

    @flash
  end
end
