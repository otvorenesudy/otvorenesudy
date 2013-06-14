module ProceedingsHelper
  def proceeding_date(date, options = {})
    time_tag date.to_date, { format: :long }.merge(options)
  end
  
  def link_to_proceeding(proceeding, body, options = {})
    link_to body, proceeding_path(proceeding), options
  end
end
