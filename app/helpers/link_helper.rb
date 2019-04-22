module LinkHelper
  PATTERN = /[;,]\s+/

  def email_to(emails, separator = ', ')
    emails.split(PATTERN).map { |email| mail_to(email, nil, encode: :hex).ascii }.join(separator).html_safe
  end

  def phone_to(phones, separator = ', ')
    phones.split(PATTERN).map { |phone| link_to(phone.gsub(/\s+/, '&nbsp;').html_safe, "tel:#{phone}") }.join(separator).html_safe
  end
end
