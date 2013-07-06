module UserHelper
  def user_error_messages
    return if resource.errors.empty?

    resource.errors.full_messages.map { |message|
      content_tag :div, class: 'alert alert-error alert-block' do
        content_tag(:button, '&times;'.html_safe, class: 'close', :'data-dismiss' => 'alert') +
        content_tag(:p, message)
      end
    }.join.html_safe
  end
end
