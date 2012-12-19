module CourtsHelper
  def court_email(court, separator = ', ')
    court.email.split(/,\s+/).map { |email| mail_to email, nil, encode: :hex }.join(separator).html_safe
  end

  # TODO implement
  def court_phone(court, separator = ', ')
    court.phone
  end
  
  def court_map
    
  end
  
  def link_to_court(court)
    link_to court.name, court_path(court.id)
  end
end
