# frozen_string_literal: true

module LinkHelper
  PATTERN = /[;,]\s+/

  def email_to(emails, separator = ', ')
    safe_join(emails.split(PATTERN).map { |email| mail_to(email) }, separator)
  end

  def phone_to(phones, separator = ', ')
    links = phones.split(PATTERN).map do |phone|
      link_to(safe_join(phone.split(/\s+/), ' '), "tel:#{phone.delete(' ')}")
    end

    safe_join(links, separator)
  end
end
