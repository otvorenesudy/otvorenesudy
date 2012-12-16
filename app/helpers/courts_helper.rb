module CourtsHelper
  def link_to_court(court)
    link_to court.name, court_path(court.id)
  end
end
