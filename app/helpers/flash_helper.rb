# frozen_string_literal: true

module FlashHelper
  CLASSES = { alert: 'danger', error: 'danger', success: 'info', failure: 'danger', notice: 'info' }.freeze

  # The flash, and the errors of the resource a Devise form submitted, as [type, message] pairs ending with a period.
  def flash_to_messages(flash: self.flash)
    flash.now[:error] = resource.errors.full_messages.uniq if respond_to?(:resource) && resource

    flash.flat_map do |type, value|
      Array.wrap(value).compact_blank.map { |message| [type, message.end_with?('.') ? message : "#{message}."] }
    end
  end

  def flash_message_type_to_class(type)
    CLASSES.fetch(type.to_sym, 'danger')
  end
end
