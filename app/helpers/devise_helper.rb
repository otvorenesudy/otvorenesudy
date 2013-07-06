module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)

    resource.errors.full_messages.map do |message|
      content_tag :div, class: 'alert alert-error alert-block' do
        content_tag(:button, '&times;'.html_safe, class: 'close', :'data-dismiss' => 'alert') +
        content_tag(:p, message)
      end
    end.join.html_safe
  end
end
