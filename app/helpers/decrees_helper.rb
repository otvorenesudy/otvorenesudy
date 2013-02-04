module DecreesHelper
  def decree_date(date)
    time_tag date, format: :long 
  end

  def link_to_decree(decree, options = {})
    link_to decree.file_number, decree_path(decree.id), options
  end
end
