module FlashHelper
  def flash_to_messages(flash: self.flash)
    flash.now[:error] = resource.errors.full_messages.uniq if defined? resource
    flash.flat_map { |type, value|
      Array.wrap(value).map { |message|
        [type, message.end_with?('.') ? message : message + '.']
      } if value.present?
    }.compact
  end

  def flash_message_type_to_class(type)
    { alert: 'danger', error: 'danger', success: 'info', failure: 'danger', notice: 'info' }[type.to_sym] || type.to_s
  end

  def flash_message_wrap(flash: self.flash, keys: [])
    keys.each { |key| flash.now[key.to_sym] = Array.wrap(flash.now[key.to_sym]) }
  end
end
