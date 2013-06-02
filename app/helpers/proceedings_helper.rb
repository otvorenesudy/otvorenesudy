module ProceedingsHelper
  def link_to_proceeding(proceeding, body, options = {})
    link_to body, proceeding_path(proceeding), options
  end
end
