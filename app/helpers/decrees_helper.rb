module DecreesHelper
  def decree_date(date)
    time_tag date, format: :long 
  end

  def link_to_decree(decree, options = {})
    link_to decree.file_number, decree_path(decree.id), options
  end

  def external_link_to_legislation(legislation, options = {})
    if legislation.year && legislation.number
      hash = "#{legislation.paragraph}-#{legislation.section}-#{legislation.letter}"
      url  = "http://www.zakonypreludi.sk/zz/#{legislation.year}-#{legislation.number}#p#{hash}"
    else
      url = "http://www.zakonypreludi.sk/main/search.aspx?text=#{legislation.value}"
    end

    external_link_to legislation.value, url, options
  end
end
