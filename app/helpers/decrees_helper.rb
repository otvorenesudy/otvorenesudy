module DecreesHelper
  def link_to_decree(decree, options = {})
    link_to decree.file_number, decree_path(decree.id), options
  end
end
